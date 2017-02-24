module Fastlane
  module Actions
    module SharedValues
      unless (const_defined?(:BUILD_TYPES))
        BUILD_TYPES = :BUILD_TYPES
      end
    end

    class AddBuildTypeAction < Action
      def self.run(params)
        if Actions.lane_context[SharedValues::BUILD_TYPES]
            cleanedUp = Actions.lane_context[SharedValues::BUILD_TYPES].reject { |hashMap| hashMap[:name] == params[:name] }
            Actions.lane_context[SharedValues::BUILD_TYPES] = cleanedUp
        end

        hashMap = Hash.new()

        hashMap[:name] = params[:name]
        hashMap[:config] = params[:config]
        hashMap[:versionSuffix] = params[:versionSuffix]

        if Actions.lane_context[SharedValues::BUILD_TYPES]
          Actions.lane_context[SharedValues::BUILD_TYPES].push(hashMap)
        else
          Actions.lane_context[SharedValues::BUILD_TYPES] = Array.new([ hashMap ])
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "A short description with <= 80 characters of what this action does"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "You can use this action to do cool things..."
      end

      def self.available_options
        # Define all options your action supports. 
        
        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :name,
                                       env_name: "BT_NAME", # The name of the environment variable
                                       description: "The name of the build type", # a short description of this parameter
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :config,
                                       env_name: "BT_CONFIG",
                                       description: "Specifies the configuration to use",
                                       is_string: true), # true: verifies the input is a string, false: every kind of value
          FastlaneCore::ConfigItem.new(key: :versionSuffix,
                                       env_name: "BT_VERSION_SUFFIX",
                                       description: "A suffix which will be appended to the version number",
                                       is_string: true,
                                       optional: true)
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['BUILD_TYPES', 'A description of what this value contains']
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
