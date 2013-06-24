require 'test_helper'
require 'time'

module TimeSpanner
  module TimeUnits
    include TimeHelpers

    class NanosecondTest < TestCase

      before do
        @nanosecond = Nanosecond.new
      end

      it 'initializes' do
        assert @nanosecond.kind_of?(TimeUnit)
        assert_equal 13, @nanosecond.position
        assert_equal 0, @nanosecond.amount
        assert_equal 0, @nanosecond.rest
      end

      it 'calculates' do
        starting_time = Time.at Time.now.to_f
        target_time   = Time.at(starting_time.to_f, 0.002)

        nanoseconds = TimeHelpers::TimeSpan.new(starting_time, target_time).total_nanoseconds

        @nanosecond.calculate(nanoseconds)

        assert_equal 2, @nanosecond.amount
        assert_equal 0, @nanosecond.rest
      end

      it 'does not calculate with rest' do
        starting_time = Time.at Time.now.to_f
        target_time   = Time.at(starting_time.to_f, 0.0024567465)

        nanoseconds = TimeHelpers::TimeSpan.new(starting_time, target_time).total_nanoseconds
        @nanosecond.calculate(nanoseconds)

        assert_equal 2, @nanosecond.amount
        assert_equal 0, @nanosecond.rest
      end

    end
  end
end