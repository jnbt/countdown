require 'test_helper'
require 'date'

module TimeSpanner
  module TimeHelpers
    module DateHelper

      class DateHelperTest < TestCase

        it 'gives last day for date' do
          assert_equal 28, DateHelper.last_day(Date.parse("2013-02-01"))
          assert_equal 29, DateHelper.last_day(Date.parse("2012-02-01")) # leap
          assert_equal 30, DateHelper.last_day(Date.parse("2013-06-01"))
        end

        it 'gives first day for date' do
          assert_equal Date.parse("2013-02-01"), DateHelper.to_first_day(Date.parse("2013-02-13"))
        end

        describe 'leap years' do

          it 'detects leap' do
            assert DateHelper.leap?(2012)
            refute DateHelper.leap?(2011)
          end

          it 'counts no leap years' do
            starting_time = DateTime.parse("2012-03-13 00:00:00") # leap year but after February the 29th
            target_time   = DateTime.parse("2016-02-27 00:00:00") # leap year but before February the 29th

            assert_equal 0, DateHelper.leap_count(starting_time, target_time)
          end

          it 'counts 2 leap years' do
            starting_time = DateTime.parse("2011-02-13 00:00:00")
            target_time   = DateTime.parse("2017-06-01 00:00:00")

            assert_equal 2, DateHelper.leap_count(starting_time, target_time)
          end

          it 'collects 0 leap years on leap start year' do
            starting_time = DateTime.parse("2012-03-13 00:00:00") # leap year but after February the 29th
            target_time   = DateTime.parse("2015-06-01 00:00:00")

            assert DateHelper.leap_years(starting_time, target_time).empty?
          end

          it 'collects 0 leap years on leap target year' do
            starting_time = DateTime.parse("2011-01-01 00:00:00")
            target_time   = DateTime.parse("2012-02-27 00:00:00") # leap year but before February the 29th

            assert DateHelper.leap_years(starting_time, target_time).empty?
          end

          it 'collects 1 leap year' do
            starting_time = DateTime.parse("2016-01-01 00:00:00") # leap year
            target_time   = DateTime.parse("2017-06-01 00:00:00")

            assert_equal [2016],  DateHelper.leap_years(starting_time, target_time)
          end

          it 'collects 2 leap years' do
            starting_time = DateTime.parse("2012-01-01 00:00:00") # leap year
            target_time   = DateTime.parse("2016-06-01 00:00:00") # leap year

            assert_equal [2012, 2016],  DateHelper.leap_years(starting_time, target_time)
          end

        end

      end

    end

  end
end