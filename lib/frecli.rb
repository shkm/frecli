require 'frecli/version.rb'
require 'frecli/settings.rb'
require 'frecli/cache.rb'
require 'frecli/queries.rb'
require 'frecli/cli.rb'

require 'freckle_api'
require 'json'

class Frecli
  include Frecli::Queries
end
