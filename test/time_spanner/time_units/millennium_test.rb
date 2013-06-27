require 'test_helper'
require 'date'

module TimeSpanner
  module TimeUnits

    class MillenniumTest < TestCase
      include TimeHelpers

      it 'initializes' do
        millennium = Millennium.new

        assert millennium.kind_of?(TimeUnit)
        assert_equal 1, millennium.position
      end

      it 'calculates without rest' do
        starting_time = DateTime.parse('2013-04-01 00:00:00')
        target_time   = DateTime.parse('4013-04-01 00:00:00')
        millennium    = Millennium.new

        millennium.calculate(starting_time, target_time)

        assert_equal 2, millennium.amount
        assert_equal 0, millennium.rest
      end

      it 'calculates with rest (1 century in nanoseconds)' do
        starting_time = DateTime.parse('2013-01-01 00:00:00')
        target_time   = DateTime.parse('4113-01-01 00:00:00')
        millennium    = Millennium.new

        millennium.calculate(starting_time, target_time)

        assert_equal 2, millennium.amount
        assert_equal 3155695200000000000, millennium.rest
      end

      it 'calculates with rest (1 nanosecond)' do
        starting_time      = DateTime.parse('2013-01-01 00:00:00')
        target_millenniums = DateTime.parse('4113-01-01 00:00:00').to_time
        target_time        = Time.at(target_millenniums.to_r, 0.002)
        millennium         = Millennium.new

        millennium.calculate(starting_time, target_time)

        assert_equal 2, millennium.amount
        assert_equal 1, millennium.rest
      end

    end
  end
end