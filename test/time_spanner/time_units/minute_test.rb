require 'test_helper'
require 'date'

module TimeSpanner
  module TimeUnits
    include TimeHelpers

    class MinuteTest < TestCase

      before do
        @minute = Minute.new(:minute)
      end

      it 'initializes' do
        assert @minute.kind_of?(TimeUnit)
        assert_equal 9, @minute.position
        assert_equal 0, @minute.amount
        assert_equal 0, @minute.rest
      end

      it 'calculates' do
        starting_time = DateTime.parse('2013-04-03 00:00:00')
        target_time   = DateTime.parse('2013-04-03 00:02:00')

        nanos = TimeHelpers::TimeSpan.new(starting_time, target_time).total_nanos

        @minute.calculate(nanos)

        assert_equal 2, @minute.amount
        assert_equal 0, @minute.rest
      end

      it 'calculates with rest' do
        starting_time = DateTime.parse('2013-04-03 00:00:00')
        target_time   = DateTime.parse('2013-04-03 00:02:45')

        nanos      = TimeHelpers::TimeSpan.new(starting_time, target_time).total_nanos
        @minute.calculate(nanos)

        assert_equal 2, @minute.amount
        assert_equal 45000000000, @minute.rest
      end

    end
  end
end