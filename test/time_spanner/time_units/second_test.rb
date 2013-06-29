require 'test_helper'
require 'date'

module TimeSpanner
  module TimeUnits

    class SecondTest < TestCase

      it 'initializes' do
        second = Second.new

        assert second.kind_of?(TimeUnit)
        assert_equal 10, second.position
        assert_equal :seconds, second.plural_name
      end

      it 'calculates' do
        starting_time = DateTime.parse('2012-12-14 00:00:00')
        target_time   = DateTime.parse('2012-12-14 00:00:02')
        second        = Second.new

        nanoseconds = Nanosecond.duration starting_time, target_time

        second.calculate(nanoseconds)

        assert_equal 2, second.amount
        assert_equal 0, second.rest
      end

      it 'calculates with rest' do
        starting_time  = Time.at Time.now.to_r
        target_seconds = Time.at(starting_time.to_r, 2000000.0)
        target_time    = Time.at(target_seconds.to_time.to_r, 0.999)
        second         = Second.new

        nanoseconds = Nanosecond.duration starting_time, target_time
        second.calculate(nanoseconds)

        assert_equal 2, second.amount
        assert_equal 999, second.rest
      end

    end
  end
end