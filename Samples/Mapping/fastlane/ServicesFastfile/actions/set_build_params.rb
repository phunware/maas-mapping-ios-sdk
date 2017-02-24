module Fastlane
  module Actions
    module SharedValues
      unless (const_defined?(:BUILD_PARAMS))
        BUILD_PARAMS = :BUILD_PARAMS
      end
    end

    class SetBuildParamsAction < Action
      def self.run(params)
        Actions.lane_context[SharedValues::BUILD_PARAMS] = {
            :buildType => params[:buildType],
            :productFlavor => params[:productFlavor],
            :otaServer => params[:otaServer],
            :distribution => params[:distribution],
            :upload => params[:upload],
            :dryRun => params[:dryRun],
            :groupAliases => params[:groupAliases],
            :emails => params[:emails]
        }
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Initializes the build parameters dictionary, which tells the rest of the actions what we want to build."
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "Initializes the build parameters dictionary, which tells the rest of the actions what we want to build."
      end

      def self.available_options
        # Define all options your action supports. 
        
        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :buildType,
                                       env_name: "BP_BUILD_TYPE", # The name of the environment variable
                                       description: "Specifies which buildType to build", # a short description of this parameter
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :productFlavor,
                                       env_name: "BP_PRODUCT_FLAVOR",
                                       description: "Specifies the product flavor to build",
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :otaServer,
                                       env_name: "BP_OTA_SERVER",
                                       description: "Allows you to deploy to a specific ota server even if the fastfile contains multiple servers",
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :distribution,
                                       env_name: "BP_DISTRIBUTION",
                                       description: "Use the distribution ota servers",
                                       is_string: false,
                                       default_value: false),
          FastlaneCore::ConfigItem.new(key: :dryRun,
                                       env_name: "BP_DRY_RUN",
                                       description: "Don't actually build anything, just show what settings are being invoked",
                                       is_string: false,
                                       default_value: false),
          FastlaneCore::ConfigItem.new(key: :upload,
                                       env_name: "BP_UPLOAD",
                                       description: "Should upload to ota or not",
                                       is_string: false,
                                       default_value: false),
          FastlaneCore::ConfigItem.new(key: :groupAliases,
                                       env_name: "GROUP_ALIAS",
                                       description: "Which Crashlytics group aliases to send beta to",
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :emails,
                                       env_name: "EMAILS",
                                       description: "Which Crashlytics emails to send beta to",
                                       is_string: true)

        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['BUILD_PARAMS', 'A hash containing all of the parameters of the build.']
        ]
      end

      def self.return_value
        # If you method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["gdimartino-phunware"]
      end

      def self.is_supported?(platform)
        # you can do things like
        # 
        #  true
        # 
        #  platform == :ios
        # 
        #  [:ios, :mac].include?(platform)
        # 

        platform == :ios
      end
    end
  end
end
