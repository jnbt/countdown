require 'test_helper'
require 'date'

module TimeSpanner
  module TimeUnits
    include TimeHelpers

    class MinuteTest < TestCase

      before do
        @minute = Minute.new
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

        nanoseconds = TimeUnitCollection.new(starting_time, target_time, [:nanoseconds]).total_nanoseconds

        @minute.calculate(nanoseconds)

        assert_equal 2, @minute.amount
        assert_equal 0, @minute.rest
      end

      it 'calculates with rest' do
        starting_time  = DateTime.parse('2013-04-03 00:00:00')
        target_minutes = DateTime.parse('2013-04-03 00:02:00')
        target_time    = Time.at(target_minutes.to_time.to_r, 0.999)

        nanoseconds = TimeUnitCollection.new(starting_time, target_time, [:nanoseconds]).total_nanoseconds
        @minute.calculate(nanoseconds)

        assert_equal 2, @minute.amount
        assert_equal 999, @minute.rest
      end

    end
  end
end