require 'test_helper'

module TimeSpanner
  module TimeUnits

    class YearTest < TestCase

      it 'initializes' do
        year = Year.new

        assert year.kind_of?(CalendarUnit)
        assert_equal 4, year.position
        assert_equal :years, year.plural_name
      end

      it 'calculates without rest' do
        from     = Time.parse('2013-04-01 00:00:00')
        to       = Time.parse('2015-04-01 00:00:00')
        duration = to.to_r - from.to_r
        year     = Year.new

        year.calculate duration, to

        assert_equal 2, year.amount
        assert_equal 0, year.rest
      end

      it 'calculates with rest (11 months in seconds)' do
        from     = Time.parse('2013-01-01 00:00:00')
        to       = Time.parse('2015-12-01 00:00:00')
        duration = to.to_r - from.to_r
        year     = Year.new

        year.calculate duration, to

        assert_equal 2, year.amount
        assert_equal 28857600, year.rest
      end

      it 'calculates with rest (11 months and 2 seconds in seconds)' do
        from     = Time.parse('2013-01-01 00:00:02')
        to       = Time.parse('2015-12-01 00:00:04')
        duration = to.to_r - from.to_r
        year     = Year.new

        year.calculate duration, to

        assert_equal 2, year.amount
        assert_equal 28857602, year.rest
      end

      it 'calculates with rest (1 second)' do
        from     = Time.parse('2012-01-01 00:00:00')
        to       = Time.parse('4014-01-01 00:00:01')
        duration = to.to_r - from.to_r
        year     = Year.new

        year.calculate duration, to

        assert_equal 2002, year.amount
        assert_equal 1, year.rest
      end

      it 'calculates correctly on exact leap day' do
        from     = Time.parse('2012-02-29 00:00:00') # leap year
        to       = Time.parse('2013-02-28 00:00:00')
        duration = to.to_r - from.to_r
        year     = Year.new

        year.calculate duration, to

        assert_equal 1, year.amount
        assert_equal 0, year.rest
      end

    end
  end
end