require 'test_helper'

module TimeSpanner
  module TimeUnits

    class TimeUnitTest < TestCase

      it 'initializes' do
        time_unit = TimeUnit.new(1)

        assert time_unit.is_a?(TimeUnit)
        assert_equal 1, time_unit.position
        assert_equal 1, time_unit.multiplier
      end

      it 'initializes with multiplier' do
        time_unit = TimeUnit.new(1, 1000)

        assert_equal 1000, time_unit.multiplier
      end

      it 'calculates' do
        time_unit = TimeUnit.new(1, 100)
        time_unit.calculate(1009)

        assert_equal 10, time_unit.amount
        assert_equal 9, time_unit.rest
      end

    end
  end
end