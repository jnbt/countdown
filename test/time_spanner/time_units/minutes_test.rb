require 'test_helper'
require 'date'

module TimeSpanner
  module TimeUnits
    include TimeHelpers

    class MinutesTest < TestCase

      before do
        @minutes = Minutes.new
      end

      it 'initializes' do
        assert @minutes.kind_of?(TimeUnit)
        assert_equal 9, @minutes.position
        assert_equal 0, @minutes.amount
        assert_equal 0, @minutes.rest
      end

      it 'calculates' do
        starting_time = DateTime.parse('2013-04-03 00:00:00')
        target_time   = DateTime.parse('2013-04-03 00:02:00')

        nanoseconds = TimeHelpers::TimeSpan.new(starting_time, target_time).total_nanoseconds

        @minutes.calculate(nanoseconds)

        assert_equal 2, @minutes.amount
        assert_equal 0, @minutes.rest
      end

      it 'calculates with rest' do
        starting_time = DateTime.parse('2013-04-03 00:00:00')
        target_time   = DateTime.parse('2013-04-03 00:02:45')

        nanoseconds = TimeHelpers::TimeSpan.new(starting_time, target_time).total_nanoseconds
        @minutes.calculate(nanoseconds)

        assert_equal 2, @minutes.amount
        assert_equal 45000000000, @minutes.rest
      end

    end
  end
end