module Fastlane
  module Actions
    module SharedValues
      unless (const_defined?(:XCODE_SELECT_VALUE))
        XCODE_SELECT_VALUE = :XCODE_SELECT_VALUE
      end
    end

    class JenkinsXcodeSelectAction < Action
      def self.run(params)
        version = params[:version]

        if Helper.is_ci?
          req = Gem::Requirement.new(version.to_s)

          require 'xcode/install'

          # list xcode paths inside /Applications
          installed = Dir.glob('/Applications/Xcode*').map { |x| XcodeInstall::InstalledXcode.new(x) }.sort do |a, b|
            Gem::Version.new(a.version) <=> Gem::Version.new(b.version)
          end

          xcode = installed.reverse.detect do |xcode|
            req.satisfied_by? Gem::Version.new(xcode.version)
          end

          UI.user_error!("Cannot find an installed Xcode satisfying '#{version}'") if xcode.nil?

          Actions.lane_context[SharedValues::XCODE_SELECT_VALUE] = xcode.version.to_s
          
          UI.verbose("Found Xcode version #{xcode.version} at #{xcode.path} satisfying requirement #{version}")
          UI.message("Setting Xcode version to #{xcode.path} for all build steps")

          ENV["DEVELOPER_DIR"] = File.join(xcode.path, "/Contents/Developer")
        else
          Fastlane::Actions::XcversionAction.run(version: version)
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Xcode select for Jenkins since xcversion doesn't work on Jenkins"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "A secondary way for jenkins to perform xcode select"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :version,
                                       env_name: "FL_XCODE_VERSION",
                                       description: "The version of Xcode to select specified as a Gem::Version requirement string (e.g. '~> 7.1.0')",
                                       optional: false,
                                       verify_block: Helper::XcversionHelper::Verify.method(:requirement))
        ]
      end

      def self.output
        # none
      end

      def self.return_value
        # If you method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["Phunware/Cef Ramirez"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
