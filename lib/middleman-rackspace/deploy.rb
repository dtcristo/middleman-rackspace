require 'fog'
require 'typhoeus'

module Middleman
  module Rackspace
    module_function

    def deploy(app, environment)
      config = app.extensions[:rackspace].options

      container_name = case environment
                       when 'staging'
                         config.container_staging
                       when 'production'
                         config.container_production
                       end

      puts ''
      puts "Deploying for #{environment} to '#{container_name}'"

      # build_ENVIRONMENT_TIMESTAMP.tar.gz
      archive_name = "build_#{environment}_#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}.tar.gz"
      puts ''
      puts "Creating archive '#{archive_name}'"

      # Compress /build directory into build_ENVIRONMENT_TIMESTAMP.tar.gz
      system("cd ./build && tar -zcvf ../#{archive_name} .")

      # Configure Fog
      service = Fog::Storage.new({
          provider:           'Rackspace',
          rackspace_username: config.rackspace_username,
          rackspace_api_key:  config.rackspace_api_key,
          rackspace_region:   config.rackspace_region,
          connection_options: {}
      })

      # Get or create container
      root_directory = service.directories.get(container_name)
      unless root_directory
        puts ''
        puts "Creating container '#{container_name}'"
        # Create the new container
        root_directory = service.directories.create(key: container_name, public: true)
        # Configure container for static site hosting
        # https://developer.rackspace.com/docs/cloud-files/v1/developer-guide/#create-a-static-website
        Typhoeus.post("#{service.endpoint_uri.to_s}/#{container_name}",
                      headers: {'X-Auth-Token' => service.send(:auth_token),
                                'X-Container-Meta-Web-Index' => config.index_file,
                                'X-Container-Meta-Web-Error' => config.error_file_prefix})
      end

      puts ''
      puts "Updating container '#{root_directory.key}'"

      # Upload and extract tar.gz on Rackspace
      # https://developer.rackspace.com/docs/cloud-files/v1/developer-guide/#extracting-archive-files
      service.extract_archive(container_name, File.open(archive_name, 'r'), 'tar.gz')

      puts ''
      puts "Site is live at: #{root_directory.public_url}"
      puts ''
    end
  end
end
