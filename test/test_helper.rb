require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/reporters'
require 'time_spanner'
require 'countdown'

MiniTest::Reporters.use!

class TestCase < Minitest::Spec
end

class FakeView
  include ::Countdown::ViewHelpers
end