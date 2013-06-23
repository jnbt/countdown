source 'https://rubygems.org'

# Specify your gem's dependencies in countdown.gemspec
gemspec

group :test do
  if RUBY_PLATFORM =~ /(win32|w32)/
    gem 'win32console', '1.3.0'
  end
  gem 'minitest'
  gem 'minitest-reporters'
end