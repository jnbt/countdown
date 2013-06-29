require 'test_helper'

module TimeSpanner
  module TimeUnits

    class HourTest < TestCase

      it 'initializes' do
        hour = Hour.new

        assert hour.kind_of?(TimeUnit)
        assert_equal 8, hour.position
        assert_equal :hours, hour.plural_name
      end

      it 'calculates without rest' do
        starting_time = DateTime.parse('2013-04-03 00:00:00')
        target_time   = DateTime.parse('2013-04-03 02:00:00')
        hour          = Hour.new

        nanoseconds = Nanosecond.duration starting_time, target_time
        hour.calculate(nanoseconds)

        assert_equal 2, hour.amount
        assert_equal 0, hour.rest
      end

      it 'calculates with rest' do
        starting_time = DateTime.parse('2013-04-03 00:00:00')
        target_hours  = DateTime.parse('2013-04-03 02:00:00')
        target_time   = Time.at(target_hours.to_time.to_r, 0.999)
        hour          = Hour.new

        nanoseconds = Nanosecond.duration starting_time, target_time
        hour.calculate(nanoseconds)

        assert_equal 2, hour.amount
        assert_equal 999, hour.rest
      end

    end
  end
end