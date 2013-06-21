require 'time_spanner/time_helpers/date_helper'
require 'time_spanner/time_helpers/time_span'

module TimeSpanner

  class TimeSpanBuilder
    include TimeSpanner::TimeHelpers

    attr_reader :reverse, :start_time, :target_time, :time_span

    # TODO: test reversing
    def initialize(start_time, target_time, options={})
      @reverse     = target_time < start_time
      @start_time  = reverse ? target_time : start_time
      @target_time = reverse ? start_time : target_time
      @time_span   = TimeSpan.new(@start_time, @target_time) # Interesting: if I use attr_readers for start- and target time nano-calculation is inaccurate!
    end

    def duration
      @__duration ||= format_units
    end

    private

    # Countdown with negative values because target_time is before start_time.
    def reverse?
      reverse
    end

    def format_units
      unless reverse?
        {
            millenniums: time_span.millenniums,
            centuries: time_span.centuries,
            decades: time_span.decades,
            years: time_span.years,
            months: time_span.months,
            weeks: time_span.weeks,
            days: time_span.days,
            hours: time_span.hours,
            minutes: time_span.minutes,
            seconds: time_span.seconds,
            millis: time_span.millis,
            micros: time_span.micros,
            nanos: time_span.nanos
        }
      else
        {
            millenniums: -time_span.millenniums,
            centuries: -time_span.centuries,
            decades: -time_span.decades,
            years: -time_span.years,
            months: -time_span.months,
            weeks: -time_span.weeks,
            days: -time_span.days,
            hours: -time_span.hours,
            minutes: -time_span.minutes,
            seconds: -time_span.seconds,
            millis: -time_span.millis,
            micros: -time_span.micros,
            nanos: -time_span.nanos
        }
      end
    end

  end
end