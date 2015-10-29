# Require core library
require 'middleman-core'

module Middleman
  module Rackspace
    @options
    class << self
      attr_accessor :options
    end

    class Extension < ::Middleman::Extension
      option :foo, '************ DEFAULT *************', 'An example option'
      option :rackspace_username, ENV['RACKSPACE_USERNAME'], 'Rackspace username'
      option :rackspace_api_key, ENV['RACKSPACE_API_KEY'], 'Rackspace API key'
      option :rackspace_region, :dfw, 'Rackspace region'
      # Dallas-Fort Worth (DFW)
      # Chicago (ORD)
      # Northern Virginia (IAD)
      # London (LON)
      # Sydney (SYD)
      # Hong Kong (HKG)
      option :container_name, nil, 'The target container on Rackspace'
      option :index_file, 'index.html', 'Index filename configuration'
      option :error_file, '.html', 'Error filename configuration'
      # 401.html
      # 404.html
      option :after_build, false, 'Deploy after build'

      def initialize(app, options_hash={}, &block)
        super
      end

      def after_configuration
        puts "#{options.foo}... after_configuration"
        ::Middleman::Rackspace.options = options
      end

      def after_build
        ::Middleman::Rackspace.deploy if options.after_build
      end

      # A Sitemap Manipulator
      # def manipulate_resource_list(resources)
      # end

      # helpers do
      #   def a_helper
      #   end
      # end
    end
  end
end
