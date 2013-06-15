require 'minitest/autorun'
require 'minitest/spec'
require 'countdown'

class TestCase < Minitest::Spec
end

class FakeView
  include ::Countdown::ViewHelpers
end