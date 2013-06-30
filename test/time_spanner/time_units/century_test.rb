require 'test_helper'

module TimeSpanner
  module TimeUnits

    class CenturyTest < TestCase

      it 'initializes' do
        century = Century.new

        assert century.kind_of?(CalendarUnit)
        assert_equal 2, century.position
        assert_equal :centuries, century.plural_name
      end

      it 'calculates without rest' do
        from     = Time.parse('2013-04-01 00:00:00')
        to       = Time.parse('2213-04-01 00:00:00')
        duration = to.to_r - from.to_r
        century  = Century.new

        century.calculate duration, to

        assert_equal 2, century.amount
        assert_equal 0, century.rest
      end

      it 'calculates with rest (1 day in seconds)' do
        from     = Time.parse('2013-01-01 00:00:00')
        to       = Time.parse('2213-01-02 00:00:00')
        duration = to.to_r - from.to_r
        century  = Century.new

        century.calculate duration, to

        assert_equal 2, century.amount
        assert_equal 86400, century.rest
      end

    end
  end
end