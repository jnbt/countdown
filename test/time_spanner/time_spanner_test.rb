require 'test_helper'

module TimeSpanner
  class TimeSpannerTest < TestCase

    it 'should create a builder instance' do
      from    = Time.now
      to      = from+1
      options = {}
      builder = TimeSpanner.new(from, to, options)

      assert builder.is_a?(TimeSpanBuilder)
    end

    it 'should ensure Time class' do
      [Date, DateTime].each do |time|
        assert_raises InvalidClassError do
          TimeSpanner.new(DateTime.now, DateTime.now)
        end
      end
    end

  end
end
