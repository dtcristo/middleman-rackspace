require 'middleman-core/cli'

module Middleman
  module Cli
    class Rackspace < Thor
      include Thor::Actions

      check_unknown_options!

      namespace :rackspace

      desc 'rackspace ENVIRONMENT [options]', 'Deploy to Rackspace container for ENVIRONMENT'

      class_option :git,
                   aliases: '-g',
                   type: :boolean,
                   desc: 'Checkout environment branch before the build/deploy step'

      class_option :build,
                   aliases: '-b',
                   type: :boolean,
                   desc: 'Run `middleman build` before the deploy step'

      # Tell Thor to exit with a non-zero exit code on failure
      def self.exit_on_failure?
        true
      end

      def rackspace(environment)
        unless environment == 'staging' || environment == 'production'
          raise Thor::Error, "Unknown environment '#{environment}'. Use 'staging' or 'production'."
        end

        # Instantiate Middleman and load config
        app = Middleman::Application.server.inst

        # Pull the Rackspace config out of 'app'
        config = app.extensions[:rackspace].options

        # Use git if specified with '--git' or in 'config.rb'
        git_enabled = options[:git] || config.git
        original_branch = ''
        switching = false
        stash = ''
        if git_enabled
          original_branch = `git rev-parse --abbrev-ref HEAD`.chomp
          branch = case environment
                   when 'staging'
                     config.branch_staging
                   when 'production'
                     config.branch_production
                   end
          switching = original_branch != branch

          stash = `git stash create`
          unless stash.empty?
            puts ''
            puts 'Working changes have been stashed. On failure, manually restore with:'
            puts ''
            puts "    git stash apply #{stash}"
          end

          # Switch branch if needed and have a clean working tree
          if switching
            puts ''
            puts "Checking out '#{branch}' branch."
            run("git checkout #{branch} --force") || exit(1)
          elsif !stash.empty?
            puts ''
            puts 'Cleaning working tree.'
            run('git reset --hard') || exit(1)
          end

          # Do a 'git pull' to update the branch from the remote
          puts ''
          puts 'Updating branch from remote.'
          run('git pull') || exit(1)
        end

        # Run `middleman build` if specified with '--build' or in 'config.rb'
        if options[:build] || config.build
          puts ''
          puts 'Building site.'
          run('middleman build') || exit(1)
        end

        # Deploy the built website
        Middleman::Rackspace.deploy(app, environment)

        # Change back to original branch and restore any saved stash
        if git_enabled
          if switching
            puts ''
            puts "Switching back to '#{original_branch}' branch."
            run("git checkout #{original_branch}") || exit(1)
          end
          unless stash.empty?
            puts ''
            puts "Restoring working changes."
            run("git stash apply #{stash}") || exit(1)
          end
        end
      end
    end
  end
end
