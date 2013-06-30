require 'test_helper'

module TimeSpanner
  module TimeUnits

    class DayTest < TestCase

      it 'initializes' do
        day = Day.new

        assert day.kind_of?(TimeUnit)
        assert_equal 7, day.position
        assert_equal :days, day.plural_name
      end

      it 'calculates without rest' do
        from     = Time.parse('2013-04-03 00:00:00')
        to       = Time.parse('2013-04-05 00:00:00')
        duration = Nanosecond.duration from, to
        day      = Day.new

        day.calculate duration, to

        assert_equal 2, day.amount
        assert_equal 0, day.rest
      end

      it 'calculates with rest' do
        from        = Time.parse('2013-04-03 00:00:00')
        target_days = Time.parse('2013-04-05 00:00:00')
        to          = Time.at(target_days.to_time.to_r, 0.999)
        duration    = Nanosecond.duration from, to
        day         = Day.new

        day.calculate duration, to

        assert_equal 2, day.amount
        assert_equal 999, day.rest
      end

      describe 'leap days' do

        it 'calculates correctly without leap day' do
          from     = Time.parse('2013-01-01 00:00:00')
          to       = Time.parse('2014-01-01 00:00:00')
          duration = Nanosecond.duration from, to
          day      = Day.new

          day.calculate duration, to

          assert_equal 365, day.amount
          assert_equal 0, day.rest
        end

        it 'calculates correctly on leap day' do
          from     = Time.parse('2012-01-01 00:00:00') # leap year
          to       = Time.parse('2013-01-01 00:00:00')
          duration = Nanosecond.duration from, to
          day      = Day.new

          day.calculate duration, to

          assert_equal 366, day.amount
          assert_equal 0, day.rest
        end

      end

    end
  end
end