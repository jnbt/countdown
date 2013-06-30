require 'test_helper'

module TimeSpanner
  module TimeUnits

    class MillenniumTest < TestCase

      it 'initializes' do
        millennium = Millennium.new

        assert millennium.kind_of?(CalendarUnit)
        assert_equal 1, millennium.position
        assert_equal :millenniums, millennium.plural_name
      end

      it 'calculates without rest' do
        from       = Time.parse('2013-04-01 00:00:00')
        to         = Time.parse('3013-04-01 00:00:00')
        duration   = to.to_r - from.to_r
        millennium = Millennium.new

        millennium.calculate duration, to

        assert_equal 1, millennium.amount
        assert_equal 0, millennium.rest
      end

      it 'calculates with rest (1 minute in seconds)' do
        from       = Time.parse('3013-01-01 00:00:00')
        to         = Time.parse('5013-01-01 00:01:00')
        duration   = to.to_r - from.to_r
        millennium = Millennium.new

        millennium.calculate duration, to

        assert_equal 2, millennium.amount
        assert_equal 60, millennium.rest
      end

      it 'calculates with rest (1 nanosecond)' do
        from               = Time.parse('3013-01-01 00:00:00')
        target_millenniums = Time.parse('5013-01-01 00:00:00')
        to                 = Time.at(target_millenniums.to_r, 0.001)
        duration           = to.to_r - from.to_r
        millennium         = Millennium.new

        millennium.calculate duration, to

        assert_equal 2, millennium.amount
        assert_equal Rational(1152921504606847, 1152921504606846976000000), millennium.rest
      end

    end
  end
end