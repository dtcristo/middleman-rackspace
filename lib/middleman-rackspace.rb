require 'middleman-core'
require 'middleman-rackspace/pkg-info'
require 'middleman-rackspace/deploy'
require 'middleman-rackspace/cli'
require 'middleman-rackspace/extension'

::Middleman::Extensions.register(:rackspace) do
  ::Middleman::Rackspace::Extension
end
