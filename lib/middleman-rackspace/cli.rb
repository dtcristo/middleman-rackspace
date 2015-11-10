require 'middleman-core/cli'

module Middleman
  module Cli
    class Rackspace < Thor
      include Thor::Actions

      check_unknown_options!

      namespace :rackspace

      desc 'rackspace ENVIRONMENT [options]', 'Deploy to Rackspace container for ENVIRONMENT'

      class_option :build_before,
                   aliases: '-b',
                   type: :boolean,
                   #default: false,
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

        # Run `middleman build` if specified with '-b' or in 'config.rb'
        build_enabled = options[:build_before] || app.extensions[:rackspace].options.build_before
        if build_enabled
          run('middleman build') || exit(1)
        end

        # Deploy the built website
        Middleman::Rackspace.deploy(app, environment)
      end
    end
  end
end
