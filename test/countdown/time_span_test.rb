require 'test_helper'
require 'date'
require 'timecop'

module Countdown
  class TimeSpanTest < TestCase

    before do
      @now = DateTime.now
    end

    it 'should calculate 0 for all time units' do
      time_span     = TimeSpan.new(@now, @now)

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

    describe 'duration in micros' do

      it 'should calculate duration for 1 day in the future' do
        assert_equal 86400000000, TimeSpan.new(@now, @now+1).duration_in_micros
      end

      it 'should calculate duration for 1 day in the past' do
        assert_equal -86400000000, TimeSpan.new(@now, @now-1).duration_in_micros
      end

      it 'should calculate duration for same timestamp' do
        assert_equal 0, TimeSpan.new(@now, @now).duration_in_micros
      end

      it 'should calculate duration for last week' do
        assert_equal 86400000000, TimeSpan.new(@now-7, @now-6).duration_in_micros
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

    describe 'unix epoch' do

      it 'should calculate dates before 1970' do
        starting_time = DateTime.parse("1960-01-01 00:00:00")
        target_time   = DateTime.parse("2010-01-01 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        refute target_time == starting_time

        expected = {centuries: 0, decades: 5, years: 0, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0}
        assert_equal expected.sort, time_span.duration.sort
      end

      it 'should calculate dates after 1970' do
        starting_time = DateTime.parse("1960-01-01 00:00:00")
        target_time   = DateTime.parse("2050-01-01 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        refute target_time == starting_time

        expected = {centuries: 0, decades: 9, years: 0, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0}
        assert_equal expected.sort, time_span.duration.sort
      end

    end

    describe 'year edge cases' do

      it 'has no leap year' do
        starting_time = DateTime.parse("2013-01-01 00:00:00")
        target_time   = DateTime.parse("2014-01-01 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        expected = {centuries: 0, decades: 0, years: 1, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0}
        assert_equal expected.sort, time_span.duration.sort
      end

      it 'should be 1 year on exact leap date (start is leap)' do
        starting_time = DateTime.parse("2012-02-29 00:00:00") # leap year
        target_time   = DateTime.parse("2013-02-28 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        expected = {centuries: 0, decades: 0, years: 1, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0}
        assert_equal expected.sort, time_span.duration.sort
      end

      it 'should be 1 year on exact leap date (target is leap)' do
        starting_time = DateTime.parse("2011-02-28 00:00:00")
        target_time   = DateTime.parse("2012-02-29 00:00:00") # leap year
        time_span     = TimeSpan.new(starting_time, target_time)

        expected = {centuries: 0, decades: 0, years: 1, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0}
        assert_equal expected.sort, time_span.duration.sort
      end

      it 'has 1 leap year' do
        starting_time = DateTime.parse("2012-01-01 00:00:00") # leap year
        target_time   = DateTime.parse("2013-01-01 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        expected = {centuries: 0, decades: 0, years: 1, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0}
        assert_equal expected.sort, time_span.duration.sort
      end

      it 'has 1 leap year within 3 years' do
        starting_time = DateTime.parse("2012-01-01 00:00:00") # leap year
        target_time   = DateTime.parse("2015-01-01 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        expected = {centuries: 0, decades: 0, years: 3, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0}
        assert_equal expected.sort, time_span.duration.sort
      end

      it 'has 2 leap years within 4 years' do
        starting_time = DateTime.parse("2012-01-01 00:00:00") # leap year
        target_time   = DateTime.parse("2016-01-01 00:00:00") # leap year
        time_span     = TimeSpan.new(starting_time, target_time)

        expected = {centuries: 0, decades: 0, years: 4, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0}
        assert_equal expected.sort, time_span.duration.sort
      end

      it 'has 3 leap years within 8 years' do
        starting_time = DateTime.parse("2012-01-01 00:00:00") # leap year
        target_time   = DateTime.parse("2020-01-01 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        expected = {centuries: 0, decades: 0, years: 8, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0}
        assert_equal expected.sort, time_span.duration.sort
      end

    end

=begin
    describe 'month edge cases' do

      it 'shows 1 month although months have different total days' do
        starting_time = DateTime.parse("2012-01-31 00:00:00")
        target_time   = DateTime.parse("2012-02-29 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        expected = {centuries: 0, decades: 0, years: 0, months: 1, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0}
        assert_equal expected.sort, time_span.duration.sort
      end

      it 'shows 1 month although months have different total days (31 -> 29)' do
        starting_time = DateTime.parse("2012-01-31 00:00:00")
        target_time   = DateTime.parse("2012-02-29 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        expected = {centuries: 0, decades: 0, years: 0, months: 1, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0}
        assert_equal expected.sort, time_span.duration.sort
      end

      it 'shows 1 month although months have different total days (30 -> 31)' do
        starting_time = DateTime.parse("2012-04-30 00:00:00")
        target_time   = DateTime.parse("2012-05-31 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        expected = {centuries: 0, decades: 0, years: 0, months: 1, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0}
        assert_equal expected.sort, time_span.duration.sort
      end

      it 'shows 5 months although months have different total days' do
        starting_time = DateTime.parse("2012-01-31 00:00:00")
        target_time   = DateTime.parse("2012-06-30 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        expected = {centuries: 0, decades: 0, years: 0, months: 5, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0}
        assert_equal expected.sort, time_span.duration.sort
      end

    end
=end

    describe 'centuries' do

      it 'should calculate 1 century' do
        starting_time = DateTime.parse("2000-06-02 00:00:00")
        target_time   = DateTime.parse("2100-06-02 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal 1, time_span.centuries
        assert_all_zero_except(time_span, :centuries)
      end

      it 'should calculate 2 centuries' do
        starting_time = DateTime.parse("1900-06-02 00:00:00")
        target_time   = DateTime.parse("2100-06-02 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal 2, time_span.centuries
        assert_all_zero_except(time_span, :centuries)
      end

    end

    describe 'decades' do

      it 'should calculate 1 decade' do
        starting_time = DateTime.parse("2010-06-02 00:00:00")
        target_time   = DateTime.parse("2020-06-02 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal 1, time_span.decades
        assert_all_zero_except(time_span, :decades)
      end

      it 'should calculate 2 decades' do
        starting_time = DateTime.parse("2010-06-02 00:00:00")
        target_time   = DateTime.parse("2030-06-02 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal 2, time_span.decades
        assert_all_zero_except(time_span, :decades)
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

=begin
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
=end

    describe 'weeks' do

      it 'should calculate 1 week' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2012-06-09 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal 1, time_span.weeks
        assert_all_zero_except(time_span, :weeks)
      end

      it 'should calculate 2 weeks' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2012-06-16 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal 2, time_span.weeks
        assert_all_zero_except(time_span, :weeks)
      end

    end

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

    describe 'milliseconds' do

      it 'should calculate 1 millisecond' do
        starting_time = Time.at @now.to_time.to_f
        target_time   = Time.at(starting_time.to_f+0.001)
        time_span     = TimeSpan.new(starting_time, target_time)

        refute target_time == starting_time

        assert_equal 1, time_span.millis
        assert_all_zero_except(time_span, :millis)
      end

      it 'should calculate 2 milliseconds' do
        starting_time = Time.at @now.to_time.to_f
        target_time   = Time.at(starting_time.to_f+0.002)
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal 2, time_span.millis
        assert_all_zero_except(time_span, :millis)
      end

    end

    describe 'microseconds' do

      it 'should calculate 1 microsecond' do
        starting_time = Time.at @now.to_time.to_f
        target_time   = Time.at(starting_time.to_f, 1.0)
        time_span     = TimeSpan.new(starting_time, target_time)

        refute target_time == starting_time

        assert_equal 1, time_span.micros
        assert_all_zero_except(time_span, :micros)
      end

      it 'should calculate 235 microseconds' do
        starting_time = Time.at @now.to_time.to_f
        target_time   = Time.at(starting_time.to_f, 235.0)
        time_span     = TimeSpan.new(starting_time, target_time)

        refute target_time == starting_time

        assert_equal 235, time_span.micros
        assert_all_zero_except(time_span, :micros)
      end

    end

    private

    def assert_all_zero_except(time_span, *time_units)
      units = [:decades, :decades, :years, :months, :weeks, :days, :hours, :minutes, :seconds, :millis, :micros] - time_units

      units.each do |time_unit|
        assert_equal 0, time_span[time_unit], "#{time_unit} should be zero!"
      end
    end

  end
end