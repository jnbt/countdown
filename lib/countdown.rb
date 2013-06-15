require 'countdown/version'
require 'countdown/view_helpers'

if defined? Rails
  require 'countdown/engine' if ::Rails.version >= '3.1'
  require 'countdown/railtie'
end