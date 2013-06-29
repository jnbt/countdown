require 'test_helper'
require 'date'

module TimeSpanner
  module TimeUnits

    class DecadeTest < TestCase

      it 'initializes' do
        decade = Decade.new

        assert decade.kind_of?(TimeUnit)
        assert_equal 3, decade.position
      end

      it 'calculates without rest' do
        starting_time = DateTime.parse('2023-04-01 00:00:00')
        target_time   = DateTime.parse('2043-04-01 00:00:00')
        decade        = Decade.new

        decade.calculate(starting_time, target_time)

        assert_equal 2, decade.amount
        assert_equal 0, decade.rest
      end

      it 'calculates with rest (1 second in nanoseconds)' do
        starting_time = DateTime.parse('2013-01-01 00:00:00')
        target_time   = DateTime.parse('2033-01-01 00:00:01')
        decade        = Decade.new

        decade.calculate(starting_time, target_time)

        assert_equal 2, decade.amount
        assert_equal 1000000000, decade.rest
      end

      it 'calculates correctly on exact leap day' do
        starting_time = DateTime.parse('2012-02-29 00:00:00') # leap year
        target_time   = DateTime.parse('2022-02-28 00:00:00')
        decade        = Decade.new

        decade.calculate(starting_time, target_time)

        assert_equal 1, decade.amount
        assert_equal 0, decade.rest
      end

    end
  end
end