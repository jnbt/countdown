require 'test_helper'

module TimeSpanner
  module TimeUnits

    class MinuteTest < TestCase

      it 'initializes' do
        minute = Minute.new

        assert minute.kind_of?(TimeUnit)
        assert_equal 9, minute.position
        assert_equal :minutes, minute.plural_name
      end

      it 'calculates' do
        starting_time = DateTime.parse('2013-04-03 00:00:00')
        target_time   = DateTime.parse('2013-04-03 00:02:00')
        minute        = Minute.new

        nanoseconds = Nanosecond.duration starting_time, target_time

        minute.calculate(nanoseconds)

        assert_equal 2, minute.amount
        assert_equal 0, minute.rest
      end

      it 'calculates with rest' do
        starting_time  = DateTime.parse('2013-04-03 00:00:00')
        target_minutes = DateTime.parse('2013-04-03 00:02:00')
        target_time    = Time.at(target_minutes.to_time.to_r, 0.999)
        minute         = Minute.new

        nanoseconds = Nanosecond.duration starting_time, target_time
        minute.calculate(nanoseconds)

        assert_equal 2, minute.amount
        assert_equal 999, minute.rest
      end

      describe 'time zone switches' do

        it 'switches to summer time' do
          starting_time = DateTime.parse('2013-03-31 01:59:00 CEST')
          target_time   = DateTime.parse('2013-03-31 02:01:00 CEST')
          minute        = Minute.new

          nanoseconds = Nanosecond.duration starting_time, target_time
          minute.calculate(nanoseconds)

          assert_equal 2, minute.amount
          assert_equal 0, minute.rest
        end

        it 'switches to winter time' do
          starting_time = DateTime.parse('2013-10-31 02:59:00 CEST')
          target_time   = DateTime.parse('2013-10-31 03:01:00 CEST')
          minute        = Minute.new

          nanoseconds = Nanosecond.duration starting_time, target_time
          minute.calculate(nanoseconds)

          assert_equal 2, minute.amount
          assert_equal 0, minute.rest
        end

      end

    end
  end
end