module Fastlane
  module Actions
    module SharedValues
      unless (const_defined?(:PRODUCT_FLAVORS))
        PRODUCT_FLAVORS = :PRODUCT_FLAVORS
      end
    end

    class AddProductFlavorAction < Action
      def self.run(params)
        if Actions.lane_context[SharedValues::PRODUCT_FLAVORS]
            cleanedUp = Actions.lane_context[SharedValues::PRODUCT_FLAVORS].reject { |hashMap| hashMap[:name] == params[:name] }
            Actions.lane_context[SharedValues::PRODUCT_FLAVORS] = cleanedUp
        end
        
        hashMap = Hash.new()

        hashMap[:name] = params[:name]
        hashMap[:scheme] = params[:scheme]
        hashMap[:iconFile] = params[:iconFile]
        hashMap[:bundleId] = params[:bundleId]
        
        if Actions.lane_context[SharedValues::PRODUCT_FLAVORS]
          Actions.lane_context[SharedValues::PRODUCT_FLAVORS].push(hashMap)
        else
          Actions.lane_context[SharedValues::PRODUCT_FLAVORS] = Array.new([ hashMap ])
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
                                       env_name: "BF_NAME", # The name of the environment variable
                                       description: "The name of the build flavor", # a short description of this parameter
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :scheme,
                                       env_name: "BF_SCHEME",
                                       description: "Specifies the scheme to use",
                                       is_string: true), # true: verifies the input is a string, false: every kind of value
          FastlaneCore::ConfigItem.new(key: :iconFile,
                                       env_name: "BF_ICON_FILE", # The name of the environment variable
                                       description: "The icon file to use", # a short description of this parameter
                                       is_string: true,
                                       optional: true,
                                       verify_block: proc do |value|
                                         v = File.expand_path(value.to_s)
                                         UI.user_error!("Icon file not found at path '#{v}'") unless File.exist?(v)
                                       end),
          FastlaneCore::ConfigItem.new(key: :bundleId,
                                       env_name: "BF_BUNDLE_ID",
                                       description: "Override the bundle id for this flavor",
                                       is_string: true,
                                       optional: true)
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['PRODUCT_FLAVORS', 'A description of what this value contains']
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
