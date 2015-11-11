require 'middleman-core/cli'

module Middleman
  module Cli
    class Rackspace < Thor
      include Thor::Actions

      check_unknown_options!

      namespace :rackspace

      desc 'rackspace ENVIRONMENT [options]', 'Deploy to Rackspace container for ENVIRONMENT'

      class_option :checkout_branch,
                   aliases: '-c',
                   type: :boolean,
                   desc: 'Checkout environment branch before the build/deploy step'

      class_option :build_before,
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

        # Checkout branch if specified with '--checkout_branch' or in 'config.rb'
        original_branch = ''
        stash = ''
        checkout_enabled = options[:checkout_branch] || config.checkout_branch
        switching = false
        if checkout_enabled
          original_branch = `git rev-parse --abbrev-ref HEAD`
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
            puts ''
          end

          if switching
            run("git checkout #{branch} --force") || exit(1)
          elsif !stash.empty?
            run('git reset --hard') || exit(1)
          end
          run('git pull') || exit(1)
        end

        # Run `middleman build` if specified with '-b' or in 'config.rb'
        if options[:build_before] || config.build_before
          run('middleman build') || exit(1)
        end

        # Deploy the built website
        Middleman::Rackspace.deploy(app, environment)

        # Change back to original branch and restore any saved stash
        if checkout_enabled
          unless original_branch.empty?
            run("git checkout #{original_branch}") || exit(1)
          end
          unless stash.empty?
            run("git stash apply #{stash}") || exit(1)
          end
        end
      end
    end
  end
end
