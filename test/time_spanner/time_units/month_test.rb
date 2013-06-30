require 'test_helper'

module TimeSpanner
  module TimeUnits

    class MonthTest < TestCase

      it 'initializes' do
        month = Month.new

        assert month.kind_of?(CalendarUnit)
        assert_equal 5, month.position
        assert_equal :months, month.plural_name
      end

      it 'calculates without rest' do
        from     = Time.parse('2013-04-01 00:00:00')
        to       = Time.parse('2013-06-01 00:00:00')
        duration = to.to_r - from.to_r
        month    = Month.new

        month.calculate duration, to

        assert_equal 2, month.amount
        assert_equal 0, month.rest
      end

      it 'calculates with rest (999 nanoseconds)' do
        from          = Time.parse('2013-04-01 00:00:00')
        target_months = Time.parse('2013-06-01 00:00:00')
        to            = Time.at(target_months.to_r, 0.999)
        duration      = to.to_r - from.to_r
        month         = Month.new

        month.calculate duration, to

        assert_equal 2, month.amount
        assert_equal Rational(8998192055486251, 9007199254740992000000), month.rest
      end

      it 'calculates with rest (19 days in seconds)' do
        from     = Time.parse('2013-04-12 00:00:00')
        to       = Time.parse('2013-07-31 00:00:00')
        duration = to.to_r - from.to_r
        month    = Month.new

        month.calculate duration, to

        assert_equal 3, month.amount
        assert_equal 1641600, month.rest
      end

    end
  end
end