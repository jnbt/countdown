require 'rails'

# Supply generator for Rails 3.0.x or if asset pipeline is not enabled
if ::Rails.version < "3.1" || !::Rails.application.config.assets.enabled
  module Countdown
    module Generators
      class InstallGenerator < ::Rails::Generators::Base
        desc "This generator installs countdown"
        source_root File.expand_path('../../../../../vendor/assets/javascripts', __FILE__)

        def copy
          say_status("copying", "countdown", :green)
          copy_file "countdown.js", "public/javascripts/countdown.js"
        end
      end
    end
  end
else
  module Countdown
    module Generators
      class InstallGenerator < ::Rails::Generators::Base
        desc "Just show instructions so people will know what to do when mistakenly using generator for Rails 3.1 apps"

        def do_nothing
          say_status("deprecated", "You are using Rails 3.1 with the asset pipeline enabled, so this generator is not needed.")
          say_status("", "The necessary files are already in your asset pipeline.")
          say_status("", "Just add `//= require countdown` to your app/assets/javascripts/application.js")
        end
      end
    end
  end
end