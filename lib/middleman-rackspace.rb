require 'middleman-core'

::Middleman::Extensions.register(:rackspace) do
  require 'middleman-rackspace/extension'
  ::Middleman::Rackspace::Extension
end
