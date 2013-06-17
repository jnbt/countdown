require 'test_helper'
require 'date'
require 'timecop'

module Countdown
  class TimeSpanTest < TestCase

    before do
      @now = DateTime.now
    end

    it 'gathers upcoming years' do
      starting_time = DateTime.parse("2012-06-02 00:00:00")
      target_time   = DateTime.parse("2014-06-02 00:00:00")
      time_span     = TimeSpan.new(starting_time, target_time)

      assert_equal [2012, 2013, 2014], time_span.upcoming_years
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

    it 'should calculate 0 for all time units' do
      starting_time = DateTime.parse("2012-06-02 00:00:00")
      target_time   = DateTime.parse("2012-06-02 00:00:00")
      time_span     = TimeSpan.new(starting_time, target_time)

      assert_all_zero_except(time_span, nil)
    end

    describe 'years' do

      it 'should calculate 1 year' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2013-06-02 00:00:00")
        time_span     = TimeSpan.new(starting_time, target_time)

        assert_equal 1, time_span.years
        assert_all_zero_except(time_span, :years)
      end

      it 'should calculate 2 years' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2014-06-02 00:00:00")
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

    private

    def assert_all_zero_except(time_span, *time_units)
      units = [:years, :months, :weeks, :days, :hours, :minutes, :seconds, :millis] - time_units

      units.each do |time_unit|
        assert_equal 0, time_span[time_unit], "#{time_unit} should be zero!"
      end
    end

  end
end