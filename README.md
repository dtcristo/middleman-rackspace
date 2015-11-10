# Middleman Rackspace

Deploy your [Middleman](https://middlemanapp.com/) site to [Rackspace Cloud Files](http://www.rackspace.com/cloud/files).

# Usage

Add the following to the `Gemfile` for you Middleman project and perform a `bundle install`.

```ruby
gem 'middleman-rackspace'
```

After configuration, you can deploy to the production container with:

```
$ middleman rackspace production
```

To deploy to the staging container, use:

```
$ middleman rackspace staging
```

An archive `build_ENVIRONMENT_TIMESTAMP.tar.gz` is created for your current build and pushed to Rackspace. A new container will automatically be configured on the specified region. If there is an existing container with the same name, **data will be overwritten**.

# Configuration

Activate and configure middleman-rackspace by adding an `activate :rackspace` block to `config.rb`. For example:

```ruby
# Example configuration
activate :rackspace do |config|
  config.rackspace_username   = 'username'
  config.rackspace_api_key    = 'a99c75008c3f4ccd31ce67a0674db356'
  config.rackspace_region     = :syd
  config.container_staging    = 'example-container-staging'
  config.container_production = 'example-container'
  config.build_before         = true
end
```

Here is a list of all configuration options available with their default values.

```ruby
# Default configuration
activate :rackspace do |config|
  # Rackspace credentials
  config.rackspace_username   = ENV['RACKSPACE_USERNAME']
  config.rackspace_api_key    = ENV['RACKSPACE_API_KEY']
  # The Rackspace region to deploy to
  config.rackspace_region     = :dfw
  # The target container on Rackspace for staging
  config.container_staging    = nil
  # The target container on Rackspace for production
  config.container_production = nil
  # Root page filename
  config.index_file           = 'index.html'
  # Error page filename prefix, translates to 401.html and 404.html
  config.error_file_prefix    = '.html'
  # Run `middleman build` before the deploy step
  config.build_before         = false
end
```

For a list of available regions see [http://www.rackspace.com/knowledge_center/article/about-regions](http://www.rackspace.com/knowledge_center/article/about-regions).

# Todo

* On deploy, delete files on the server that have been removed from the build.
* Invalidate cache after deploy.
* Integrate with git to deploy from a branch.
* Improve CLI to deploy from a pre-built `build_ENVIRONMENT_TIMESTAMP.tar.gz`.
* Improve error handling.
