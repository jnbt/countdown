require 'date'

module Countdown
  class TimeSpan

    COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    attr_reader :reverse,
                :start_time,
                :target_time,
                :duration_in_nanos,
                :millenniums, :centuries, :decades, :years, :months, :weeks, :days, :hours, :minutes, :seconds, :millis, :micros, :nanos

    def initialize(start_time, target_time)
      @reverse           = target_time < start_time
      @start_time        = reverse ? target_time : start_time
      @target_time       = reverse ? start_time : target_time
      @duration_in_nanos = set_duration_in_nanos

      calculate_units
    end

    def [](unit)
      send unit
    end

    def duration
      @__duration ||= format_units
    end

    def set_duration_in_nanos
      ((target_time.to_time.to_r - start_time.to_time.to_r).round(9) * 1000000000).to_i
    end

    def leap_years
      leap_years = (start_time.year..target_time.year).to_a.select{|year| leap?(year)}

      leap_years.shift if leap?(start_time.year) && start_time >= Date.new(start_time.year, 2, 29) # starting_time >= 2012-02-29 has no leap days (after February 29th!)
      leap_years.pop if leap?(target_time.year) && target_time < Date.new(target_time.year, 2, 28) # target_time <= 2012-02-28 has no leap days (before February 29th!)

      leap_years
    end

    def leap_count
      leap_years.size
    end

    # TODO: slow if a duration of 1000 years needs to be calculated...
    def upcoming_months
      dates = []
      first_day_in_month(start_time.to_date).upto(first_day_in_month(target_time)) do |date|
        dates << date if date.day == 1
      end
      dates
    end

    def days_in_month(date)
      month = date.month
      return 29 if month == 2 && leap?(date.year)
      COMMON_YEAR_DAYS_IN_MONTH[month]
    end

    def first_day_in_month(date)
      Date.new(date.year, date.month, 1)
    end

    def days_by_upcoming_months
      upcoming_months.map do |date|
        days_in_month(date)
      end
    end

    def months_for_days(days)
      days.divmod(30)
    end

    private

    def calculate_units
      remaining_micros, @nanos    = duration_in_nanos.divmod(1000)
      remaining_millis, @micros   = remaining_micros.divmod(1000)
      remaining_seconds, @millis  = remaining_millis.divmod(1000)
      remaining_minutes, @seconds = remaining_seconds.divmod(60)
      remaining_hours, @minutes   = remaining_minutes.divmod(60)
      remaining_days, @hours      = remaining_hours.divmod(24)

      remaining_days -= leap_count

      remaining_years, days        = remaining_days.divmod(365)
      remaining_decades, @years     = remaining_years.divmod(10)
      remaining_centuries, @decades = remaining_decades.divmod(10)
      @millenniums, @centuries       = remaining_centuries.divmod(10)


      #years, months = years.divmod(12)
      @months = 0

      @weeks, @days  = days.divmod(7)

      minusify_units
    end

    # Countdown with negative values because target_time is before start_time.
    def reverse?
      reverse
    end

    def leap?(year)
      Date.gregorian_leap?(year)
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