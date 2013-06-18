require 'test_helper'
require 'date'
require 'timecop'

module Countdown
  class TimeSpanTest < TestCase

    before do
      @now = DateTime.now
    end

    it 'should calculate 0 for all time units' do
      starting_time = DateTime.parse(@now)
      target_time   = DateTime.parse(@now)
      time_span     = TimeSpan.new(starting_time, target_time)

      assert_all_zero_except(time_span, nil)
    end

    describe "day helpers" do

      it 'shows day count for date' do
        time_span = TimeSpan.new(@now, @now)

        assert_equal 28, time_span.days_in_month(Date.parse("2013-02-01"))
        assert_equal 30, time_span.days_in_month(Date.parse("2013-06-01"))
      end

      it 'gathers days by upcoming months' do
        starting_time = DateTime.parse("2013-06-01 00:00:00")
        target_time   = DateTime.parse("2013-12-01 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal [30, 31, 31, 30, 31, 30, 31], time_span.days_by_upcoming_months
      end

      it 'converts date first day in month' do
        time_span = TimeSpan.new(@now, @now)

        assert_equal Date.parse("2013-02-01"), time_span.first_day_in_month(Date.parse("2013-02-13"))
      end

    end

    describe 'duration in millis' do

      it 'should calculate duration for 1 day in the future' do
        assert_equal 86400000, TimeSpan.new(@now, @now+1).duration_in_ms
      end

      it 'should calculate duration for 1 day in the past' do
        assert_equal -86400000, TimeSpan.new(@now, @now-1).duration_in_ms
      end

      it 'should calculate duration for same timestamp' do
        assert_equal 0, TimeSpan.new(@now, @now).duration_in_ms
      end

      it 'should calculate duration for last week' do
        assert_equal 86400000, TimeSpan.new(@now-7, @now-6).duration_in_ms
      end

    end

    describe 'collects leap years' do

      it 'collects 0 leap years on leap start year' do
        starting_time = DateTime.parse("2012-03-13 00:00:00") # leap year but after February the 29th
        target_time   = DateTime.parse("2015-06-01 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert time_span.leap_years.empty?
        assert_equal 0, time_span.leap_count
      end

      it 'collects 0 leap years on leap target year' do
        starting_time = DateTime.parse("2011-01-01 00:00:00")
        target_time   = DateTime.parse("2012-02-27 00:00:00") # leap year but before February the 29th
        time_span     = TimeSpan.new(starting_time, target_time)

        assert time_span.leap_years.empty?
        assert_equal 0, time_span.leap_count
      end

      it 'collects 1 leap year' do
        starting_time = DateTime.parse("2016-01-01 00:00:00") # leap year
        target_time   = DateTime.parse("2017-06-01 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal [2016], time_span.leap_years
        assert_equal 1, time_span.leap_count
      end

      it 'collects 2 leap years' do
        starting_time = DateTime.parse("2012-01-01 00:00:00") # leap year
        target_time   = DateTime.parse("2016-06-01 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal [2012, 2016], time_span.leap_years
        assert_equal 2, time_span.leap_count
      end

    end

    describe 'year edge cases' do

      # should be 365 days
      it 'has no leap year' do
        starting_time = DateTime.parse("2013-01-01 00:00:00")
        target_time   = DateTime.parse("2014-01-01 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        expected = {years: 1, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0}
        assert_equal expected.sort, time_span.duration.sort
      end

      # should be 1 year on exact leap date
      it 'has a leap year' do #fails
        starting_time = DateTime.parse("2012-02-29 00:00:00") # leap year
        target_time   = DateTime.parse("2013-02-28 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        expected = {years: 1, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0}
        assert_equal expected.sort, time_span.duration.sort
      end

      # fails if leap_years.size-1 is substracted
      # fails if 1 is substracted
      # should be 365 days(366-1 for leap year)
      it 'has a leap year' do #fails
        starting_time = DateTime.parse("2012-01-01 00:00:00") # leap year
        target_time   = DateTime.parse("2013-01-01 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        expected = {years: 1, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0}
        assert_equal expected.sort, time_span.duration.sort
      end

      # fails if leap_years.size-1 is substracted
      # succeeds if 1 is substracted
      # should be 1095 days(1096-1 for leap year)
      it 'has 1 leap year within 3 years' do #fails
        starting_time = DateTime.parse("2012-01-01 00:00:00") # leap year
        target_time   = DateTime.parse("2015-01-01 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        expected = {years: 3, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0}
        assert_equal expected.sort, time_span.duration.sort
      end

      # fails if leap_years.size-1 is substracted
      # fails if 1 is substracted
      # should be 1460 days(1462-2 for leap year)
      it 'has 2 leap years within 4 years' do #fails
        starting_time = DateTime.parse("2012-01-01 00:00:00") # leap year
        target_time   = DateTime.parse("2016-01-01 00:00:00") # leap year
        time_span     = TimeSpan.new(starting_time, target_time)

        expected = {years: 4, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0}
        assert_equal expected.sort, time_span.duration.sort
      end

      # succeeds if leap_years.size-1 is substracted
      # fails if 1 is substracted
      # should be 2920 days(2923-3 for leap year)
      it 'has 3 leap years within 8 years' do
        starting_time = DateTime.parse("2012-01-01 00:00:00") # leap year
        target_time   = DateTime.parse("2020-01-01 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        expected = {years: 8, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0}
        assert_equal expected.sort, time_span.duration.sort
      end

    end

    describe 'month edge cases' do

      it 'shows 1 month although months have different total days' do
        starting_time = DateTime.parse("2012-01-31 00:00:00")
        target_time   = DateTime.parse("2012-02-29 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        expected = {years: 0, months: 1, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0}
        assert_equal expected.sort, time_span.duration.sort
      end

      it 'shows 1 month although months have different total days (31 -> 29)' do
        starting_time = DateTime.parse("2012-01-31 00:00:00")
        target_time   = DateTime.parse("2012-02-29 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        expected = {years: 0, months: 1, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0}
        assert_equal expected.sort, time_span.duration.sort
      end

      it 'shows 1 month although months have different total days (30 -> 31)' do
        starting_time = DateTime.parse("2012-04-30 00:00:00")
        target_time   = DateTime.parse("2012-05-31 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        expected = {years: 0, months: 1, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0}
        assert_equal expected.sort, time_span.duration.sort
      end

      it 'shows 5 months although months have different total days' do
        starting_time = DateTime.parse("2012-01-31 00:00:00")
        target_time   = DateTime.parse("2012-06-30 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        expected = {years: 0, months: 5, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0}
        assert_equal expected.sort, time_span.duration.sort
      end

    end

    describe 'years' do

      it 'should calculate 1 year' do
        starting_time = DateTime.parse("2013-06-02 00:00:00")
        target_time   = DateTime.parse("2014-06-02 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal 1, time_span.years
        assert_all_zero_except(time_span, :years)
      end

      it 'should calculate 2 years' do
        starting_time = DateTime.parse("2013-06-02 00:00:00")
        target_time   = DateTime.parse("2015-06-02 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal 2, time_span.years
        assert_all_zero_except(time_span, :years)
      end

    end

    describe 'months' do

      it 'should calculate 1 month' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2012-07-02 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal 1, time_span.months
        assert_all_zero_except(time_span, :months)
      end

      it 'should calculate 2 months' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2012-08-02 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal 2, time_span.months
        assert_all_zero_except(time_span, :months)
      end

    end

=begin
    describe 'weeks' do

      it 'should calculate 1 week' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2012-07-09 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal 1, time_span.weeks
        assert_all_zero_except(time_span, :weeks)
      end

      it 'should calculate 2 weeks' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2012-08-16 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal 2, time_span.weeks
        assert_all_zero_except(time_span, :weeks)
      end

    end
=end

    describe 'days' do

      it 'should calculate 1 day' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2012-06-03 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal 1, time_span.days
        assert_all_zero_except(time_span, :days)
      end

      it 'should calculate 2 days' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2012-06-04 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal 2, time_span.days
        assert_all_zero_except(time_span, :days)
      end

      it 'should calculate 0 days on whole year (not leap)' do
        starting_time = DateTime.parse("2013-06-01 00:00:00")
        target_time   = DateTime.parse("2014-06-01 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal 0, time_span.days
        assert_equal 1, time_span.years
        assert_all_zero_except(time_span, :years)
      end

    end

    describe 'hours' do

      it 'should calculate 1 hour' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2012-06-02 01:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal 1, time_span.hours
        assert_all_zero_except(time_span, :hours)
      end

      it 'should calculate 2 hours' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2012-06-02 02:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal 2, time_span.hours
        assert_all_zero_except(time_span, :hours)
      end

    end

    describe 'minutes' do

      it 'should calculate 1 minute' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2012-06-02 00:01:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal 1, time_span.minutes
        assert_all_zero_except(time_span, :minutes)
      end

      it 'should calculate 2 minutes' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2012-06-02 00:02:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal 2, time_span.minutes
        assert_all_zero_except(time_span, :minutes)
      end

    end

    describe 'seconds' do

      it 'should calculate 1 seconds' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2012-06-02 00:00:01")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal 1, time_span.seconds
        assert_all_zero_except(time_span, :seconds)
      end

      it 'should calculate 2 seconds' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2012-06-02 00:00:02")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal 2, time_span.seconds
        assert_all_zero_except(time_span, :seconds)
      end

    end

=begin
    describe 'milliseconds' do

      it 'should calculate 1 millisecond' do
        starting_time = DateTime.parse("2012-06-02 00:00:00:000")
        target_time   = DateTime.parse("2012-06-02 00:00:00:001")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal 1, time_span.millis
        assert_all_zero_except(time_span, :millis)
      end

      it 'should calculate 2 milliseconds' do
        starting_time = DateTime.parse("2012-06-02 00:00:00:000")
        target_time   = DateTime.parse("2012-06-02 00:00:00:002")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal 2, time_span.millis
        assert_all_zero_except(time_span, :millis)
      end

    end
=end

    private

    def assert_all_zero_except(time_span, *time_units)
      units = [:years, :months, :weeks, :days, :hours, :minutes, :seconds, :millis] - time_units

      units.each do |time_unit|
        assert_equal 0, time_span[time_unit], "#{time_unit} should be zero!"
      end
    end

  end
end