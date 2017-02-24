module Fastlane
  module Actions
    module SharedValues
      PW_ATTRIBUTION_HTML_PATH = :PW_ATTRIBUTION_HTML_PATH
      PW_ATTRIBUTION_PLIST_PATH = :PW_ATTRIBUTION_PLIST_PATH
    end

    class GenerateAttributionsAction < Action
      def self.run(params)
        attributionFile = File.expand_path(params[:attributions_file_path])
        outputPath = params[:output_directory]
        if outputPath.nil?
          outputPath = File.dirname(attributionFile)
        else
          outputPath = File.expand_path(outputPath)
        end

        Actions.lane_context[SharedValues::PW_ATTRIBUTION_PLIST_PATH] = self.generate_attributions(params[:scriptPath], attributionFile, outputPath, 'plist')
        Actions.lane_context[SharedValues::PW_ATTRIBUTION_HTML_PATH] = self.generate_attributions(params[:scriptPath], attributionFile, outputPath, 'html')

        self.check_build_pusher_output()
      end

      #####################################################
      # @!group Private
      #####################################################

      def self.generate_attributions(scriptPath, attributionFile, outputPath, type)
          outputFile = "#{outputPath}/attributions.#{type}"

          command = "python #{scriptPath} "
          command << "-l #{attributionFile} "
          command << "-o #{outputFile} "
          command << "-t #{type} "

          if Helper.is_ci?
            command << "-n #{ENV['JOB_NAME']} "
            command << "-b build"
          end

          Actions.sh(command)
          return outputFile
      end

      def self.check_build_pusher_output
          if Helper.is_ci?
              buildPusherOutputName = File.expand_path("build/buildpusher_#{ENV['JOB_NAME']}.html")
              if File.exist?(buildPusherOutputName)
                UI.important "Found buildpusher output... which means not everything is approved."
                UI.important "Warning:  Found attribution warnings.  Sending email to (${emailList})"

                command = "cat \"#{buildPusherOutput}\" | "
                command << "mail -s \"[Jenkins] + #{ENV['JOB_NAME']}: Release build with licensing warnings\nContent-Type: text/html\"  "
                command << "#{emailList}"

                Actions.sh(command)
              end
          end
      end

      def self.attribution_email_list
        "phunware-devmanagers@phunware.com bchinn@phunware.com cdifuntorum@phunware.com #{ENV['BUILD_USER_ID']}"
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Generates the attributions.html based on the passed in ThirdParty.txt"
      end

      def self.details

      end

      def self.available_options
        # Define all options your action supports.
        [
          FastlaneCore::ConfigItem.new(key: :scriptPath,
                                       env_name: "PW_SCRIPT_PATH",
                                       description: "Path to the python script file",
                                       verify_block: proc do |value|
                                         v = File.expand_path(value.to_s)
                                         UI.user_error!("Could not find the script file at path '#{v}'") unless File.exist?(v)
                                         UI.user_error!("Script is not a python script, must end with .py") unless v.include?(".py")
                                       end),
          FastlaneCore::ConfigItem.new(key: :attributions_file_path,
                                       env_name: "PW_ATTRIBUTIONS_FILE",
                                       description: "Path to valid ThirdParty.txt file",
                                       verify_block: proc do |path|
                                         UI.user_error!("Could not find Third Party Attributions at path '#{path}'") unless File.exist?(path)
                                       end),
          FastlaneCore::ConfigItem.new(key: :output_directory,
                                       env_name: "PW_ATTRIBUTIONS_OUTPUT_DIRECTORY",
                                       description: "Directory in which to place attribution output files",
                                       optional: true)
        ]
      end

      def self.output
        [
          ['PW_ATTRIBUTION_HTML_PATH', 'The path to the generated attribution.html'],
          ['PW_ATTRIBUTION_PLIST_PATH', 'The path to the generated attribution.plist']
        ]
      end

      def self.return_value

      end

      def self.authors
        ["Phunware/Cef Ramirez"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
