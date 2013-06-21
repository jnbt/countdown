require 'test_helper'

module TimeSpanner
  class TimeSpannerTest < TestCase
    it 'should create a builder instance' do
      from    = DateTime.now
      to      = from+1
      options = {}
      builder = TimeSpanner.new(from, to, options)

      assert builder.is_a?(TimeSpanBuilder)
    end
  end
end
