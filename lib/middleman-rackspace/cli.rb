require 'middleman-cli'

module Middleman
  module Cli
    # This class provides a 'rackspace' command for the Middleman CLI
    class Rackspace < Thor::Group
      include Thor::Actions

      check_unknown_options!

      namespace :rackspace

      class_option :environment,
                   aliases: '-e',
                   default: ENV['MM_ENV'] || ENV['RACK_ENV'] || 'production',
                   desc: 'The environment Middleman will run under'

      class_option :verbose,
                   aliases: '-v',
                   type: :boolean,
                   default: false,
                   desc: 'Print debug messages'

      class_option :instrument,
                   aliases: '-i',
                   type: :string,
                   default: false,
                   desc: 'Print instrument messages'

      class_option :build_before,
                   aliases: '-b',
                   type: :boolean,
                   default: false,
                   desc: 'Run `middleman build` before the deploy step'

      # Tell Thor to exit with a non-zero exit code on failure
      def self.exit_on_failure?
        true
      end

      def rackspace
        env = options['environment'] ? :production : options['environment'].to_s.to_sym
        verbose = options['verbose'] ? 0 : 1
        instrument = options['instrument']

        @app = ::Middleman::Application.new do
          config[:mode] = :build
          config[:environment] = env
          ::Middleman::Logger.singleton(verbose, instrument)
        end
        # build_before(options)
        ::Middleman::Rackspace.deploy
      end

      protected

      # def build_before(options = {})
      #   build_enabled = options.fetch('build_before', deploy_options.build_before)
      #
      #   if build_enabled
      #     # http://forum.middlemanapp.com/t/problem-with-the-build-task-in-an-extension
      #     run("middleman build -e #{options['environment']}") || exit(1)
      #   end
      # end

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

      def rackspace_options
        options = nil

        begin
          options = ::Middleman::Rackspace.options
        rescue NoMethodError
          print_usage_and_die 'You need to activate the rackspace extension in config.rb'
        end

        # unless options.deploy_method
        #   print_usage_and_die 'The deploy extension requires you to set a method.'
        # end
        #
        # case options.deploy_method
        # when :rsync, :sftp
        #   unless options.host && options.path
        #     print_usage_and_die "The #{options.deploy_method} method requires host and path to be set."
        #   end
        # when :ftp
        #   unless options.host && options.user && options.password && options.path
        #     print_usage_and_die 'The ftp deploy method requires host, path, user, and password to be set.'
        #   end
        # end

        options
      end
    end

    # Add to CLI
    Base.register(Middleman::Cli::Rackspace, 'rackspace', 'rackspace [options]', Middleman::Rackspace::TAGLINE)
  end
end
