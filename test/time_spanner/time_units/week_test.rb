require 'test_helper'
require 'date'

module TimeSpanner
  module TimeUnits

    class WeekTest < TestCase

      it 'initializes' do
        week = Week.new

        assert week.kind_of?(TimeUnit)
        assert_equal 6, week.position
        assert_equal :weeks, week.plural_name
      end

      it 'calculates without rest' do
        starting_time = DateTime.parse('2013-04-01 00:00:00')
        target_time   = DateTime.parse('2013-04-08 00:00:00')
        week          = Week.new

        week.calculate(starting_time, target_time)

        assert_equal 1, week.amount
        assert_equal 0, week.rest
      end

      it 'calculates with rest (6 days and 1 nanosecond)' do
        starting_time = DateTime.parse('2013-04-01 00:00:00')
        target_weeks  = DateTime.parse('2013-04-21 00:00:00')
        target_time   = Time.at(target_weeks.to_time.to_r, 0.001)
        week          = Week.new

        week.calculate(starting_time, target_time)

        assert_equal 2, week.amount
        assert_equal 518400000000001, week.rest
      end

    end
  end
end