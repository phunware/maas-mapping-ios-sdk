module Fastlane
  module Actions
    module SharedValues
      TMP_RESOURCES_ROOT = :TMP_RESOURCES_ROOT
      FULL_RESOURCES_PATH = :FULL_RESOURCES_PATH
    end

    class ImportResourcesAction < Action
      def self.run(params)
        repo_name = params[:url].split("/").last

        tmp_path = Dir.mktmpdir("resources_",".")
        clone_folder = File.join(tmp_path, repo_name)

        branch_option = ""
        branch_option = "--branch #{params[:branch]}" if params[:branch] != 'HEAD'

        clone_command = "GIT_TERMINAL_PROMPT=0 git clone '#{params[:url]}' '#{clone_folder}' --depth 1 -n #{branch_option}"

        UI.message "Cloning remote git repo..."
        Actions.sh(clone_command)

        Actions.sh("cd '#{clone_folder}' && git checkout #{params[:branch]} '#{params[:path]}'")
        
        Actions.lane_context[SharedValues::TMP_RESOURCES_ROOT] = tmp_path
        Actions.lane_context[SharedValues::FULL_RESOURCES_PATH] = File.join(clone_folder, params[:path])

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
          FastlaneCore::ConfigItem.new(key: :url,
                                       env_name: "DR_URL", # The name of the environment variable
                                       description: "The git URL to clone the repository from",
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :branch,
                                       env_name: "DR_BRANCH", # The name of the environment variable
                                       description: "The branch to checkout in the repository",
                                       is_string: true,
                                       default_value: "HEAD"),
          FastlaneCore::ConfigItem.new(key: :path,
                                       env_name: "DR_PATH", # The name of the environment variable
                                       description: "The path to the resources",
                                       is_string: true,
                                       default_value: ".")
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['TMP_RESOURCES_ROOT', 'A description of what this value contains'],
          ['FULL_RESOURCES_PATH', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If you method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["Your GitHub/Twitter Name"]
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
