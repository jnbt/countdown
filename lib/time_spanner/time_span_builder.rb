require 'time_spanner/time_helpers/date_helper'
require 'time_spanner/time_helpers/time_span'

module TimeSpanner
  class TimeSpanBuilder
    include TimeSpanner::TimeHelpers

    attr_reader :reverse,
                :start_time,
                :target_time,
                :millenniums, :centuries, :decades, :years, :months, :weeks, :days, :hours, :minutes, :seconds, :millis, :micros, :nanos

    # TODO: test reversing
    def initialize(start_time, target_time, options={})
      @reverse     = target_time < start_time
      @start_time  = reverse ? target_time : start_time
      @target_time = reverse ? start_time : target_time

      calculate_units
    end

    def duration
      format_units
    end

    private

    def calculate_units
      nanos = TimeSpan.new(start_time, target_time).nanos

      remaining_micros, @nanos    = nanos.divmod(1000)
      remaining_millis, @micros   = remaining_micros.divmod(1000)
      remaining_seconds, @millis  = remaining_millis.divmod(1000)
      remaining_minutes, @seconds = remaining_seconds.divmod(60)
      remaining_hours, @minutes   = remaining_minutes.divmod(60)
      remaining_days, @hours      = remaining_hours.divmod(24)

      remaining_days -= DateHelper.leaps start_time, target_time

      remaining_years, remaining_days = remaining_days.divmod(365)

      @months, days = TimeSpan.months_and_days(target_time, remaining_days)

      remaining_decades, @years     = remaining_years.divmod(10)
      remaining_centuries, @decades = remaining_decades.divmod(10)
      @millenniums, @centuries      = remaining_centuries.divmod(10)

      @weeks, @days  = days.divmod(7)

      minusify_units
    end

    # Countdown with negative values because target_time is before start_time.
    def reverse?
      reverse
    end

    def format_units
      {
          millenniums: millenniums,
          centuries: centuries,
          decades: decades,
          years: years,
          months: months,
          weeks: weeks,
          days: days,
          hours: hours,
          minutes: minutes,
          seconds: seconds,
          millis: millis,
          micros: micros,
          nanos: nanos
      }
    end

    def minusify_units
      if reverse?
        @millenniums = -millenniums
        @centuries   = -centuries
        @decades     = -decades
        @years       = -years
        @months      = -months
        @weeks       = -weeks
        @days        = -days
        @hours       = -hours
        @minutes     = -minutes
        @seconds     = -seconds
        @millis      = -millis
        @micros      = -micros
        @nanos       = -nanos
      end
    end

  end
end