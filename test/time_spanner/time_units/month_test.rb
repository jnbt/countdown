require 'test_helper'
require 'date'

module TimeSpanner
  module TimeUnits

    class MonthTest < TestCase
      include TimeHelpers

      it 'initializes' do
        @month = Month.new DateTime.parse('2013-04-01 00:00:00'), DateTime.parse('2013-04-01 00:00:00')

        assert @month.kind_of?(TimeUnit)
        assert_equal 5, @month.position
        assert_equal 0, @month.amount
        assert_equal 0, @month.rest
      end

      it 'calculates without rest' do
        starting_time = DateTime.parse('2013-04-01 00:00:00')
        target_time   = DateTime.parse('2013-06-01 00:00:00')
        @month        = Month.new starting_time, target_time

        nanoseconds = DurationHelper.nanoseconds(starting_time, target_time)

        @month.calculate(nanoseconds)

        assert_equal 2, @month.amount
        assert_equal 0, @month.rest
      end

      it 'calculates with rest' do
        starting_time = DateTime.parse('2013-04-01 00:00:00')
        target_months = DateTime.parse('2013-06-01 00:00:00')
        target_time   = Time.at(target_months.to_time.to_r, 0.999)
        @month        = Month.new starting_time, target_time

        nanoseconds = DurationHelper.nanoseconds(starting_time, target_time)
        @month.calculate(nanoseconds)

        assert_equal 2, @month.amount
        assert_equal 999, @month.rest
      end

    end
  end
end