require 'test_helper'

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
        from     = Time.parse('2013-04-01 00:00:00')
        to       = Time.parse('2013-04-08 00:00:00')
        duration = Nanosecond.duration from, to
        week     = Week.new

        week.calculate duration, to

        assert_equal 1, week.amount
        assert_equal 0, week.rest
      end

      it 'calculates with rest (6 days and 1 nanosecond)' do
        from         = Time.parse('2013-04-01 00:00:00')
        target_weeks = Time.parse('2013-04-21 00:00:00')
        to           = Time.at(target_weeks.to_time.to_r, 0.001)
        duration     = Nanosecond.duration from, to
        week         = Week.new

        week.calculate duration, to

        assert_equal 2, week.amount
        assert_equal 518400000000001, week.rest
      end

    end
  end
end