require 'test_helper'

module TimeSpanner
  module TimeUnits

    class UnitTest < TestCase

      it 'initializes' do
        time_unit = Unit.new(1)

        assert time_unit.is_a?(Unit)
        assert_equal 1, time_unit.position
        assert_equal 0, time_unit.amount
        assert_equal 0, time_unit.rest
      end

      it "compares: Day should be in front of Hour" do
        day  = Day.new
        hour = Hour.new

        assert_equal -1, day.<=>(hour)
      end

      it "reverses!" do
        second = Second.new
        second.calculate 1

        assert_equal 1, second.amount

        second.reverse!

        assert_equal -1, second.amount
      end

    end
  end
end