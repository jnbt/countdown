require 'test_helper'
require 'date'

module TimeSpanner
  module TimeUnits
    include TimeHelpers

    class HoursTest < TestCase

      before do
        @hours = Hours.new
      end

      it 'initializes' do
        assert @hours.kind_of?(TimeUnit)
        assert_equal 8, @hours.position
        assert_equal 0, @hours.amount
        assert_equal 0, @hours.rest
      end

      it 'calculates without rest' do
        starting_time = DateTime.parse('2013-04-03 00:00:00')
        target_time   = DateTime.parse('2013-04-03 02:00:00')

        nanoseconds = TimeHelpers::TimeSpan.new(starting_time, target_time).total_nanoseconds

        @hours.calculate(nanoseconds)

        assert_equal 2, @hours.amount
        assert_equal 0, @hours.rest
      end

      it 'calculates with rest' do
        starting_time = DateTime.parse('2013-04-03 00:00:00')
        target_time   = DateTime.parse('2013-04-03 02:45:00')

        nanoseconds = TimeHelpers::TimeSpan.new(starting_time, target_time).total_nanoseconds
        @hours.calculate(nanoseconds)

        assert_equal 2, @hours.amount
        assert_equal 2700000000000, @hours.rest
      end

    end
  end
end