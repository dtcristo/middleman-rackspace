require 'middleman-core'

module Middleman
  module Rackspace
    class Extension < Middleman::Extension
      option :rackspace_username, ENV['RACKSPACE_USERNAME'], 'Rackspace username'
      option :rackspace_api_key, ENV['RACKSPACE_API_KEY'], 'Rackspace API key'
      option :rackspace_region, :dfw, 'Rackspace region'
      option :container_staging, nil, 'The target Rackspace container for staging'
      option :container_production, nil, 'The target Rackspace container for production'
      option :branch_staging, 'staging', 'Git branch for staging'
      option :branch_production, 'master', 'Git branch for production'
      option :checkout_branch, false, 'Checkout environment branch before the build/deploy step'
      option :build_before, false, 'Run `middleman build` before the deploy step'
      option :index_file, 'index.html', 'Index filename configuration'
      option :error_file_prefix, '.html', 'Error filename configuration'

      def initialize(app, options_hash={}, &block)
        super
      end
    end
  end
end
