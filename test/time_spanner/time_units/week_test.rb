require 'test_helper'
require 'date'

module TimeSpanner
  module TimeUnits

    class WeekTest < TestCase
      include TimeHelpers

      before do
        @week = Week.new
      end

      it 'initializes' do
        assert @week.kind_of?(TimeUnit)
        assert_equal 6, @week.position
        assert_equal 0, @week.amount
        assert_equal 0, @week.rest
      end

      it 'calculates without rest' do
        starting_time = DateTime.parse('2013-04-01 00:00:00')
        target_time   = DateTime.parse('2013-04-08 00:00:00')

        nanoseconds = DurationHelper.nanoseconds(starting_time, target_time)

        @week.calculate(nanoseconds)

        assert_equal 1, @week.amount
        assert_equal 0, @week.rest
      end

      it 'calculates with rest' do
        starting_time = DateTime.parse('2013-04-01 00:00:00')
        target_weeks  = DateTime.parse('2013-04-15 00:00:00')
        target_time   = Time.at(target_weeks.to_time.to_r, 0.999)

        nanoseconds = DurationHelper.nanoseconds(starting_time, target_time)
        @week.calculate(nanoseconds)

        assert_equal 2, @week.amount
        assert_equal 999, @week.rest
      end

    end
  end
end