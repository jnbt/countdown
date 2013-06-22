require 'time_spanner/time_helpers/date_helper'
require 'time_spanner/time_helpers/time_span'

module TimeSpanner

  class TimeSpanBuilder
    include TimeSpanner::TimeHelpers

    attr_reader :reverse, :start_time, :target_time, :duration

    # TODO: test reversing
    def initialize(start_time, target_time, options={})
      @reverse     = target_time < start_time
      @start_time  = reverse ? target_time : start_time
      @target_time = reverse ? start_time : target_time
      @duration    = TimeSpan.new(@start_time, @target_time) # Interesting: if I use attr_readers for start- and target time nano-calculation is inaccurate!
    end

    def time_span
      @__time_span ||= format_units
    end

    private

    # Countdown with negative values because target_time is before start_time.
    def reverse?
      reverse
    end

    def format_units
      unless reverse?
        {
            millenniums: duration.millenniums,
            centuries: duration.centuries,
            decades: duration.decades,
            years: duration.years,
            months: duration.months,
            weeks: duration.weeks,
            days: duration.days,
            hours: duration.hours,
            minutes: duration.minutes,
            seconds: duration.seconds,
            millis: duration.millis,
            micros: duration.micros,
            nanos: duration.nanos
        }
      else
        {
            millenniums: -duration.millenniums,
            centuries: -duration.centuries,
            decades: -duration.decades,
            years: -duration.years,
            months: -duration.months,
            weeks: -duration.weeks,
            days: -duration.days,
            hours: -duration.hours,
            minutes: -duration.minutes,
            seconds: -duration.seconds,
            millis: -duration.millis,
            micros: -duration.micros,
            nanos: -duration.nanos
        }
      end
    end

  end
end