require 'test_helper'

module TimeSpanner
  module TimeUnits

    class MillisecondTest < TestCase

      it 'initializes' do
        millisecond = Millisecond.new

        assert millisecond.kind_of?(TimeUnit)
        assert_equal 11, millisecond.position
        assert_equal :milliseconds, millisecond.plural_name
      end

      it 'calculates' do
        starting_time = Time.at Time.now.to_f
        target_time   = Time.at(starting_time.to_f, 2000.0)
        millisecond   = Millisecond.new

        nanoseconds = Nanosecond.duration starting_time, target_time

        millisecond.calculate(nanoseconds)

        assert_equal 2, millisecond.amount
        assert_equal 0, millisecond.rest
      end

      it 'calculates with rest' do
        starting_time = Time.at Time.now.to_r
        target_millis = Time.at(starting_time.to_r, 2000.0)
        target_time   = Time.at(target_millis.to_time.to_r, 0.999)
        millisecond   = Millisecond.new

        nanoseconds = Nanosecond.duration starting_time, target_time
        millisecond.calculate(nanoseconds)

        assert_equal 2, millisecond.amount
        assert_equal 999, millisecond.rest
      end

    end
  end
end