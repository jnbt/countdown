require 'test_helper'

module TimeSpanner
  module TimeUnits

    class TimeUnitTest < TestCase

      it 'initializes' do
        time_unit = TimeUnit.new(1, 1)

        assert time_unit.is_a?(TimeUnit)
        assert_equal 1, time_unit.position
        assert_equal 1, time_unit.multiplier
      end

    end
  end
end