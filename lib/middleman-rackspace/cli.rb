require 'middleman-core/cli'

module Middleman
  module Cli
    # This class provides a 'rackspace' command for the Middleman CLI
    class Rackspace < Thor::Group
      include Thor::Actions

      check_unknown_options!

      namespace :rackspace

      class_option :environment,
                   aliases: '-e',
                   type: :string,
                   default: ENV['MM_ENV'] || ENV['RACK_ENV'] || 'production',
                   desc: 'The environment to deploy'

      class_option :build,
                   aliases: '-b',
                   type: :boolean,
                   #default: false,
                   desc: 'Run `middleman build` before the deploy step'

      # Tell Thor to exit with a non-zero exit code on failure
      def self.exit_on_failure?
        true
      end

      def rackspace
        # @app = ::Middleman::Application.server.inst
        ::Middleman::Application.server.inst

        p config_options

        build(options)
        ::Middleman::Rackspace.deploy
      end

      protected

      def build(cli_options = {})
        build_enabled = cli_options.fetch('build', config_options.build)

        if build_enabled
          puts 'building before'
          run("middleman build -e #{cli_options['environment']}") || exit(1)
        end
      end

      def print_usage_and_die(message)
        fail StandardError, "ERROR: #{message}"
      end

      # def process
      #   server_instance   = @app
      #   camelized_method  = deploy_options.deploy_method.to_s.split('_').map(&:capitalize).join
      #   method_class_name = "Middleman::Deploy::Methods::#{camelized_method}"
      #   method_instance   = method_class_name.constantize.new(server_instance, deploy_options)
      #
      #   method_instance.process
      # end

      def config_options
        puts 'getting config options'
        options = nil

        begin
          options = ::Middleman::Rackspace.options
        rescue NoMethodError
          print_usage_and_die 'You need to activate the rackspace extension in config.rb'
        end

        puts "getting config options... #{options.class}"
        options
      end
    end

    # Add to CLI
    Base.register(Middleman::Cli::Rackspace, 'rackspace', 'rackspace [options]', Middleman::Rackspace::TAGLINE)
  end
end
