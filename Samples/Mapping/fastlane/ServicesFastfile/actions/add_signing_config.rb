module Fastlane
  module Actions
    module SharedValues
      unless (const_defined?(:SIGNING_CONFIGS))
        SIGNING_CONFIGS = :SIGNING_CONFIGS
      end
    end

    class AddSigningConfigAction < Action
      def self.run(params)
        if Actions.lane_context[SharedValues::SIGNING_CONFIGS]
            cleanedUp = Actions.lane_context[SharedValues::SIGNING_CONFIGS].reject { |hashMap| hashMap[:name] == params[:name] }
            Actions.lane_context[SharedValues::SIGNING_CONFIGS] = cleanedUp
        end

        hashMap = Hash.new()

        hashMap[:name] = params[:name]
        hashMap[:cert_file] = params[:cert_file]
        hashMap[:cert_pw] = params[:cert_pw]
        hashMap[:identity] = params[:identity]
        hashMap[:profileSpecifier] = params[:profileSpecifier]
        hashMap[:teamId] = params[:teamId]
        hashMap[:customProfilesPath] = params[:customProfilesPath]

        if Actions.lane_context[SharedValues::SIGNING_CONFIGS]
          Actions.lane_context[SharedValues::SIGNING_CONFIGS].push(hashMap)
        else
          Actions.lane_context[SharedValues::SIGNING_CONFIGS] = Array.new([ hashMap ])
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
                                       env_name: "SC_NAME", # The name of the environment variable
                                       description: "The name of the signing configuration", # a short description of this parameter
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :cert_file,
                                       env_name: "SC_CERT_FILE",
                                       description: "Specifies the certificate file name (.p12)",
                                       is_string: true), # true: verifies the input is a string, false: every kind of value
          FastlaneCore::ConfigItem.new(key: :cert_pw,
                                       env_name: "SC_CERT_PW",
                                       description: "The password for the certificate file",
                                       is_string: true), # true: verifies the input is a string, false: every kind of value
          FastlaneCore::ConfigItem.new(key: :identity,
                                       env_name: "SC_IDENTITY",
                                       description: "The certificate name",
                                       is_string: true), # true: verifies the input is a string, false: every kind of value
          FastlaneCore::ConfigItem.new(key: :teamId,
                                       env_name: "SC_TEAM_ID", # The name of the environment variable
                                       description: "Specifies the team Id", # a short description of this parameter
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :profileSpecifier,
                                       env_name: "SC_PROFILE_SPECIFIER",
                                       description: "The name of the profile to use",
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :customProfilesPath,
                                       env_name: "DC_CUSTOM_PROFILES_PATH",
                                       description: "Specifies the folder where your custom profiles live for this configuration",
                                       is_string: true,
                                       optional: true,
                                       verify_block: proc do |value|
                                         v = File.expand_path(value.to_s)
                                         UI.user_error!("Custom profile path not found: '#{v}'") unless File.exist?(v)
                                         UI.user_error!("The custom profile path must point to a directory") unless File.directory?(v)
                                       end)
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['SIGNING_CONFIGS', 'A description of what this value contains']
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
