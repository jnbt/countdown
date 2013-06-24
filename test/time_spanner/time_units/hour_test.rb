require 'test_helper'
require 'date'

module TimeSpanner
  module TimeUnits
    include TimeHelpers

    class HourTest < TestCase

      before do
        @hour = Hour.new(:hour)
      end

      it 'initializes' do
        assert @hour.kind_of?(TimeUnit)
        assert_equal 8, @hour.position
        assert_equal 0, @hour.amount
        assert_equal 0, @hour.rest
      end

      it 'calculates without rest' do
        starting_time = DateTime.parse('2013-04-03 00:00:00')
        target_time   = DateTime.parse('2013-04-03 02:00:00')

        nanos = TimeHelpers::TimeSpan.new(starting_time, target_time).total_nanos

        @hour.calculate(nanos)

        assert_equal 2, @hour.amount
        assert_equal 0, @hour.rest
      end

      it 'calculates with rest' do
        starting_time = DateTime.parse('2013-04-03 00:00:00')
        target_time   = DateTime.parse('2013-04-03 02:45:00')

        nanos      = TimeHelpers::TimeSpan.new(starting_time, target_time).total_nanos
        @hour.calculate(nanos)

        assert_equal 2, @hour.amount
        assert_equal 2700000000000, @hour.rest
      end

    end
  end
end