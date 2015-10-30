require 'middleman-core'

module Middleman
  module Rackspace
    class Extension < Middleman::Extension
      option :rackspace_username, ENV['RACKSPACE_USERNAME'], 'Rackspace username'
      option :rackspace_api_key, ENV['RACKSPACE_API_KEY'], 'Rackspace API key'
      option :rackspace_region, :dfw, 'Rackspace region'
      option :container_name, nil, 'The target container on Rackspace'
      option :index_file, 'index.html', 'Index filename configuration'
      option :error_file_prefix, '.html', 'Error filename configuration'
      option :build_before, false, 'Run `middleman build` before the deploy step'

      def initialize(app, options_hash={}, &block)
        super
      end
    end
  end
end
