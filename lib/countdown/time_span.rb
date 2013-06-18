require 'date'

module Countdown
  class TimeSpan

    COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    attr_reader :start_time, :target_time, :duration_in_ms, :years, :months, :weeks, :days, :hours, :minutes, :seconds, :millis

    def initialize(start_time, target_time)
      @start_time     = start_time
      @target_time    = target_time
      @duration_in_ms = duration_in_ms
      @years          = duration[:years]
      @months         = duration[:months]
      @weeks          = duration[:weeks]
      @days           = duration[:days]
      @hours          = duration[:hours]
      @minutes        = duration[:minutes]
      @seconds        = duration[:seconds]
      @millis         = duration[:millis]
    end

    def [](unit)
      send unit
    end

    def duration
      @__duration ||= calculate_units
    end

    def duration_in_ms
      ((target_time.to_time - start_time.to_time).to_f.round*1000).to_i
    end

    def leap_years
      # TODO:
      # Important examples: starting_time 2012-03-01 has no leap days (after February 29th!)
      # target_time 2012-01-01 has no leap days (before February 29th!)
      (start_time.year..target_time.year).to_a.select{|year| Date.gregorian_leap?(year)}
    end

    def leap_count
      leap_years.size
    end

    # TODO: probably slow if a duration of 1000 years needs to be calculated...
    def upcoming_months
      dates = []
      first_day_in_month(start_time.to_date).upto(first_day_in_month(target_time)) do |date|
        dates << date if date.day == 1
      end
      dates
    end

    def days_in_month(date)
      month = date.month
      return 29 if month == 2 && Date.gregorian_leap?(date.year)
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

    private

    def calculate_units
      rest, millis  = duration_in_ms.divmod(1000)
      rest, seconds = rest.divmod(60)
      rest, minutes = rest.divmod(60)
      days, hours   = rest.divmod(24)

      days -= leap_count

      years, days   = days.divmod(365)

      {years: years, months: 0, weeks: 0, days: days, hours: hours, minutes: minutes, seconds: seconds, millis: millis}
    end

  end
end