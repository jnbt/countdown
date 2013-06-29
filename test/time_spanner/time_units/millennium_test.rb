require 'test_helper'

module TimeSpanner
  module TimeUnits

    class MillenniumTest < TestCase

      it 'initializes' do
        millennium = Millennium.new

        assert millennium.kind_of?(TimeUnit)
        assert_equal 1, millennium.position
        assert_equal :millenniums, millennium.plural_name
      end

      it 'calculates without rest' do
        starting_time = DateTime.parse('2013-04-01 00:00:00')
        target_time   = DateTime.parse('3013-04-01 00:00:00')
        millennium    = Millennium.new

        millennium.calculate(starting_time, target_time)

        assert_equal 1, millennium.amount
        assert_equal 0, millennium.rest
      end

      it 'calculates with rest (1 minute in nanoseconds)' do
        starting_time = DateTime.parse('3013-01-01 00:00:00')
        target_time   = DateTime.parse('5013-01-01 00:01:00')
        millennium    = Millennium.new

        millennium.calculate(starting_time, target_time)

        assert_equal 2, millennium.amount
        assert_equal 60000000000, millennium.rest
      end

      it 'calculates with rest (1 nanosecond)' do
        starting_time      = DateTime.parse('3013-01-01 00:00:00')
        target_millenniums = DateTime.parse('5013-01-01 00:00:00')
        target_time        = Time.at(target_millenniums.to_time.to_r, 0.001)
        millennium         = Millennium.new

        millennium.calculate(starting_time, target_time)

        assert_equal 2, millennium.amount
        assert_equal 1, millennium.rest
      end

    end
  end
end