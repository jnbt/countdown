require 'test_helper'
require 'time'

module TimeSpanner
  module TimeUnits

    class NanosecondTest < TestCase
      include TimeHelpers

      before do
        @nanosecond = Nanosecond.new
      end

      it 'initializes' do
        assert @nanosecond.kind_of?(TimeUnit)
        assert_equal 13, @nanosecond.position
      end

      it 'calculates' do
        starting_time = Time.at Time.now.to_f
        target_time   = Time.at(starting_time.to_f, 0.002)

        nanoseconds = DurationHelper.nanoseconds(starting_time, target_time)

        @nanosecond.calculate(nanoseconds)

        assert_equal 2, @nanosecond.amount
        assert_equal 0, @nanosecond.rest
      end

      it 'calculate without rest' do
        starting_time = Time.at Time.now.to_r
        target_time   = Time.at(starting_time.to_r, 0.0024567465)

        nanoseconds = DurationHelper.nanoseconds(starting_time, target_time)
        @nanosecond.calculate(nanoseconds)

        assert_equal 2, @nanosecond.amount
        assert_equal 0, @nanosecond.rest
      end

    end
  end
end