require 'test_helper'

module TimeSpanner
  class TimeSpannerTest < TestCase

    it 'creates a builder instance' do
      from    = Time.now
      to      = from + 1
      options = {}
      builder = TimeSpanner.new(from, to, options)

      assert builder.is_a?(TimeSpanBuilder)
    end

    it 'ensures converting to Time' do
      InvalidClass = Class.new do
        def to_time; false end
      end

      assert_raises InvalidClassError do
        TimeSpanner.new(InvalidClass.new, InvalidClass.new)
      end
    end

  end
end
