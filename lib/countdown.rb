require 'time_spanner'

require 'countdown/version'
require 'countdown/content_tag'
require 'countdown/tag_builders'
require 'countdown/view_helpers'

if defined? Rails
  require 'countdown/engine' if ::Rails.version >= '3.1'
  require 'countdown/railtie'
end