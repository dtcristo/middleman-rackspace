# Middleman Rackspace

Deploy your Middleman site to Rackspace Cloud Files.

# Installation

Add the following to the `Gemfile` for you Middleman project and perform an `bundle install`.

```ruby
gem 'middleman-rackspace'
```

After configuration, you can deploy to the specified region and container with the following command.

```
$ middleman rackspace
```

# Configuration

Activate and configure middleman-rackspace by adding an `activate :rackspace` block to `config.rb`. Below is an example.

```ruby
activate :rackspace do |config|
  config.rackspace_username = 'username'
  config.rackspace_api_key  = 'a99c75008c3f4ccd31ce67a0674db356'
  config.rackspace_region   = :syd
  config.container_name     = 'example-site'
  config.build_before       = true
end
```

Here is a list of all configuration options available with their default values.

```ruby
activate :rackspace do |config|
  config.rackspace_username = ENV['RACKSPACE_USERNAME']
  config.rackspace_api_key  = ENV['RACKSPACE_API_KEY']
  # Available regions include:
  #   Dallas-Fort Worth :dfw
  #   Chicago           :ord
  #   Northern Virginia :iad
  #   London            :lon
  #   Sydney            :syd
  #   Hong Kong         :hkg
  config.rackspace_region   = :dfw
  config.container_name     = nil
  config.index_file         = 'index.html'
  # Translates to 401.html and 404.html
  config.error_file_prefix  = '.html'
  # Run `middleman build` before the deploy step
  config.build_before       = false
end
```
