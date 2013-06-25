require 'test_helper'
require 'date'

module TimeSpanner
  module TimeUnits

    class MicrosecondTest < TestCase
      include TimeHelpers

      before do
        @microsecond = Microsecond.new
      end

      it 'initializes' do
        assert @microsecond.kind_of?(TimeUnit)
        assert_equal 12, @microsecond.position
        assert_equal 0, @microsecond.amount
        assert_equal 0, @microsecond.rest
      end

      it 'calculates' do
        starting_time = Time.at Time.now.to_f
        target_time   = Time.at(starting_time.to_f, 2.0)

        nanoseconds = DurationHelper.nanoseconds(starting_time, target_time)

        @microsecond.calculate(nanoseconds)

        assert_equal 2, @microsecond.amount
        assert_equal 0, @microsecond.rest
      end

      it 'calculates with rest' do
        starting_time = Time.at Time.now.to_r
        target_micros = Time.at(starting_time.to_r, 2.0)
        target_time   = Time.at(target_micros.to_time.to_r, 0.999)

        nanoseconds = DurationHelper.nanoseconds(starting_time, target_time)
        @microsecond.calculate(nanoseconds)

        assert_equal 2, @microsecond.amount
        assert_equal 999, @microsecond.rest
      end

    end
  end
end