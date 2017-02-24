module Fastlane
  module Actions
    module SharedValues
      unless (const_defined?(:DEFAULT_CONFIG))
        DEFAULT_CONFIG = :DEFAULT_CONFIG
      end
    end

    class DefaultConfigAction < Action
      def self.run(params)
        hashMap = Hash.new()

        hashMap[:scheme] = params[:scheme]
        hashMap[:iconFile] = params[:iconFile]
        hashMap[:bundleId] = params[:bundleId]
        hashMap[:thirdPartyAttributions] = params[:thirdPartyAttributions]

        if params[:workspace]
            hashMap[:workspace] = params[:workspace]
        elsif params[:project]
            hashMap[:project] = params[:project]
        end

        Actions.lane_context[SharedValues::DEFAULT_CONFIG] = hashMap        
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Specify the values to use when no product flavors are defined."
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "Specify the values to use when no product flavors are defined. Also allows you to specify other settings that are global to the build."
      end

      def self.available_options
        # Define all options your action supports. 
        
        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :scheme,
                                       env_name: "DC_SCHEME", # The name of the environment variable
                                       description: "Specifies which scheme to build", # a short description of this parameter
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :iconFile,
                                       env_name: "DC_ICON_FILE", # The name of the environment variable
                                       description: "The icon file to use", # a short description of this parameter
                                       is_string: true,
                                       optional: true,
                                       verify_block: proc do |value|
                                         v = File.expand_path(value.to_s)
                                         UI.user_error!("Icon file not found at path '#{v}'") unless File.exist?(v)
                                       end),
          FastlaneCore::ConfigItem.new(key: :bundleId,
                                       env_name: "DC_BUNDLE_ID",
                                       description: "Override the bundle id",
                                       is_string: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :workspace,
                                       env_name: "DC_WORKSPACE",
                                       description: "Specifies the workspace file to use",
                                       is_string: true,
                                       optional: true,
                                       conflicting_options: [:project],
                                       verify_block: proc do |value|
                                         v = File.expand_path(value.to_s)
                                         UI.user_error!("Workspace file not found at path '#{v}'") unless File.exist?(v)
                                         UI.user_error!("Workspace file invalid") unless File.directory?(v)
                                         UI.user_error!("Workspace file is not a workspace, must end with .xcworkspace") unless v.include?(".xcworkspace")
                                       end),
          FastlaneCore::ConfigItem.new(key: :project,
                                       env_name: "DC_PROJECT",
                                       description: "Specifies the project file to use",
                                       is_string: true,
                                       optional: true,
                                       conflicting_options: [:workspace],
                                       verify_block: proc do |value|
                                         v = File.expand_path(value.to_s)
                                         UI.user_error!("Project file not found at path '#{v}'") unless File.exist?(v)
                                         UI.user_error!("Project file invalid") unless File.directory?(v)
                                         UI.user_error!("Project file is not a project file, must end with .xcodeproj") unless v.include?(".xcodeproj")
                                       end),
          FastlaneCore::ConfigItem.new(key: :thirdPartyAttributions,
                                       env_name: "DC_THIRD_PARTY_ATTRIBUTIONS",
                                       description: "Path to your attributions file",
                                       is_string: true,
                                       optional: true,
                                       verify_block: proc do |value|
                                         v = File.expand_path(value.to_s)
                                         UI.user_error!("Attributions file not found at path '#{v}'") unless File.exist?(v)
                                       end)
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['DEFAULT_CONFIG', 'A hash containing the settings to use when no product flavors are defined.']
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
