module Fastlane
  module Actions
    module SharedValues
      unless (const_defined?(:JENKINS_INFO))
        JENKINS_INFO = :JENKINS_INFO
      end
    end

    class OtaAction < Action
      def self.run(params)
        UI.message "Running OTA scripts"

        ipaPath = Actions.lane_context[SharedValues::IPA_OUTPUT_PATH]
        displayName = Fastlane::Actions::GetIpaInfoPlistValueAction.run(ipa: ipaPath, key: "CFBundleName")
        version = Fastlane::Actions::GetIpaInfoPlistValueAction.run(ipa: ipaPath, key: "CFBundleShortVersionString")
        buildNumber = Fastlane::Actions::GetIpaInfoPlistValueAction.run(ipa: ipaPath, key: "CFBundleVersion")
        bundleId = Fastlane::Actions::GetIpaInfoPlistValueAction.run(ipa: ipaPath, key: "CFBundleIdentifier")
        
        scpHost = "att-corpvmintra01.gotvnetworks.com"
        scpUser = "ota"
        scpPath = (params[:distribution] ? "/data/ota-dist-builds" : "/data/ota-adhoc-builds" )
        codesign = params[:codesign]
        iconFile = params[:iconFile]

        # rename the ipa file to include version and build number
        # also remove any spaces in the name
        baseDir = File.dirname(ipaPath)
        otaDir = "#{baseDir}/#{codesign}"

        # make sure otaDir exists
        Actions.sh("mkdir -p #{otaDir}")

        ipaName = File.basename(ipaPath, '.*').gsub(/\s+/, "")
        filename = "#{ipaName}_#{version}_#{buildNumber}_#{codesign}.ipa"
        renamedPath = File.join(otaDir, filename)

        # copy original ipa to ota directory
        Actions.sh("cp \"#{ipaPath}\" \"#{renamedPath}\"")

        # generate plist inside ota dir
        generate_wireless_distribution_plist("#{otaDir}/distribution.plist", {
            :displayName => displayName,
            :version => version,
            :buildNumber => buildNumber,
            :bundleId => bundleId,
            :codesign => codesign
          });
        
        if Actions.lane_context[SharedValues::JENKINS_INFO]
          otaUrlsMap = Actions.lane_context[SharedValues::JENKINS_INFO]
        else
          otaUrlsMap = Hash.new()
          Actions.lane_context[SharedValues::JENKINS_INFO] = otaUrlsMap
        end
        
        otaUrlsMap[:displayName] = displayName
        otaUrlsMap[:version] = version
        otaUrlsMap[:buildNumber] = buildNumber
        otaUrlsMap[:bundleId] = bundleId
        
        if Helper.is_ci? && params[:upload]
          UI.message "Uploading to Phunware OTA Server"
          begin
            do_upload_sh(scpHost, scpUser, scpPath, otaDir, bundleId, buildNumber, iconFile)
            otaUrl = generate_ota_url(params[:distribution], codesign, bundleId, buildNumber)

            if otaUrlsMap[:servers]
                serversMap = otaUrlsMap[:servers]
            else
                serversMap = Hash.new()
                otaUrlsMap[:servers] = serversMap
            end
            
            serversMap[codesign] = otaUrl

            UI.message "Build uploaded to OTA: #{otaUrl}"
          rescue => ex
            UI.error(ex)
            UI.error("Failed to upload build to OTA!!")
          end
        else
          UI.message "Skipping upload!"
        end

      end

      def self.generate_ota_url(dist, codesign, bundleId, buildNumber)

        otaServer = dist ? "ota2-dist" : "ota2"
        flavor = case codesign
            when "custom" then "custom"
            when "submit" then "submit"
            else "e"
          end

        return "https://#{otaServer}-#{flavor}.phunware.com/?id=#{bundleId}.#{buildNumber}"
      end

      # Use shell ssh instead of Ruby SSH
      def self.do_upload_sh(scpHost, scpUser, scpPath, otaDir, bundleId, buildNumber, iconFile)
        # create upload path
        sshUserAndHost = "#{scpUser}@#{scpHost}"
        Actions.sh("ssh #{sshUserAndHost} sudo mkdir -p #{scpPath}/#{bundleId}/v#{buildNumber}")
        Actions.sh("ssh #{sshUserAndHost} sudo chown -R ota:ota #{scpPath}/#{bundleId}")

        # scp files over
        Actions.sh("scp -r #{otaDir} #{sshUserAndHost}:#{scpPath}/#{bundleId}/v#{buildNumber}")

        # upload icon, if available
        unless iconFile.nil?
          if File::exist?(iconFile)
            Actions.sh("scp -r #{iconFile} #{sshUserAndHost}:#{scpPath}/#{bundleId}")
          end
        end

        # configure ota ownership
        Actions.sh("ssh #{sshUserAndHost} sudo chown -R www-data:www-data #{scpPath}/#{bundleId}")
        Actions.sh("ssh #{sshUserAndHost} sudo chmod -R g+w #{scpPath}/#{bundleId}")
      end

      def self.do_upload(scpHost, scpUser, scpPath, otaDir, bundleId, buildNumber, iconFile)
        # create upload path
        Fastlane::Actions::SshAction.run(
          host: scpHost,
          username: scpUser,
          commands: [
            "sudo mkdir -p #{scpPath}/#{bundleId}/v#{buildNumber}",
            "sudo chown -R ota:ota #{scpPath}/#{bundleId}"
          ]
        )

        # scp files over
        Fastlane::Actions::ScpAction.run(
          host: scpHost,
          username: scpUser,
          upload: {
            src: otaDir,
            dst: "#{scpPath}/#{bundleId}/v#{buildNumber}"
          }
        )

        # upload icon, if available
        unless iconFile.nil?
          if File::exist?(iconFile)
            Fastlane::Actions::ScpAction.run(
              host: scpHost,
              username: scpUser,
              upload: {
                src: iconFile,
                dst: "#{scpPath}/#{bundleId}"
              }
            )
          end
        end

        # configure ota ownership
        Fastlane::Actions::SshAction.run(
          host: scpHost,
          username: scpUser,
          commands: [
            "sudo chown -R www-data:www-data #{scpPath}/#{bundleId}",
            "sudo chmod -R g+w #{scpPath}/#{bundleId}"
          ]
        )
      end

      def self.generate_wireless_distribution_plist(destination, params)
        require 'erb'

        template = get_wireless_distribution_template()
        renderer = ERB.new(template)
        os = OpenStruct.new(params)
        output = renderer.result(os.instance_eval { binding })
        File.open(destination, 'w'){ |file| file.write(output) }
      end

      def self.get_wireless_distribution_template()
          return '<?xml version="1.0" encoding="UTF-8"?>
                  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
                  <plist version="1.0">
                  <dict>
                  <key>items</key>
                  <array>
                  <dict>
                  <key>assets</key>
                  <array>
                  <dict>
                  <key>kind</key>
                  <string>software-package</string>
                  <key>url</key>
                  <string>__URL__</string>
                  </dict>
                  </array>
                  <key>metadata</key>
                  <dict>
                  <key>bundle-identifier</key>
                  <string><%= bundleId %></string>
                  <key>bundle-version</key>
                  <string><%= buildNumber %></string>
                  <key>kind</key>
                  <string>software</string>
                  <key>title</key>
                  <string><%= displayName %></string>
                  <key>subtitle</key>
                  <string><%= version %></string>
                  <key>codesign</key>
                  <string><%= codesign %></string>
                  </dict>
                  </dict>
                  </array>
                  </dict>
                  </plist>
                  '
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Uploads the built IPA files to Phunware OTA"
      end

      def self.details
        "Very nice.."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :codesign,
                                       env_name: "PH_OTA_CODESIGN", # The name of the environment variable
                                       description: "The flavor of which server to upload to", # a short description of this parameter
                                       default_value: "pe"),
          FastlaneCore::ConfigItem.new(key: :distribution,
                                       env_name: "PH_OTA_DISTRIBUTION",
                                       description: "Whether this is a distribution build or not",
                                       is_string: false, # true: verifies the input is a string, false: every kind of value
                                       default_value: false), # the default value if the user didn't provide one
          FastlaneCore::ConfigItem.new(key: :iconFile,
                                       env_name: "PH_OTA_ICONFILE",
                                       description: "Path to the icon file to use for this app",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :upload,
                                       env_name: "PH_OTA_UPLOAD",
                                       description: "Should upload or not",
                                       is_string: false,
                                       default_value: false)
        ]
      end

      def self.output
        [
          ['JENKINS_INFO', 'Information about the build to be included in the Jenkins Description string']
        ]
      end

      def self.return_value
        # If you method provides a return value, you can describe here what it does
        "The OTA URL from which to download the application"
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["Phunware/CefRamirez"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
