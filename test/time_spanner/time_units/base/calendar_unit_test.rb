require 'test_helper'

module TimeSpanner
  module TimeUnits

    class CalendarUnitTest < TestCase

      it 'initializes' do
        time_unit = CalendarUnit.new(1)

        assert time_unit.is_a?(CalendarUnit)
        assert_equal 1, time_unit.position
      end

    end
  end
end