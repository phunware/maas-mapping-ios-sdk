module Fastlane
  module Actions
    module SharedValues
      unless (const_defined?(:OTA_SERVERS))
        OTA_SERVERS = :OTA_SERVERS
      end
    end

    class PublishToEnterpriseOtaAction < Action
      def self.run(params)
        if Actions.lane_context[SharedValues::OTA_SERVERS]
            cleanedUp = Actions.lane_context[SharedValues::OTA_SERVERS].reject { |hashMap| hashMap[:name] == "enterprise" }
            Actions.lane_context[SharedValues::OTA_SERVERS] = cleanedUp
        end
        
        hashMap = Hash.new()

        hashMap[:name] = "enterprise"
        hashMap[:signingConfig] = params[:signingConfig]

        if Actions.lane_context[SharedValues::OTA_SERVERS]
          Actions.lane_context[SharedValues::OTA_SERVERS].push(hashMap)
        else
          Actions.lane_context[SharedValues::OTA_SERVERS] = Array.new([ hashMap ])
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
          FastlaneCore::ConfigItem.new(key: :signingConfig,
                                       env_name: "OTA_SIGNING_CONFIG", # The name of the environment variable
                                       description: "Specifies the signing configuration to use",
                                       is_string: true)
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['OTA_SERVERS', 'A description of what this value contains']
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
