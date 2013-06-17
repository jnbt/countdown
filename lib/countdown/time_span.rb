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

    def leap_years
      upcoming_years.select{|year| Date.gregorian_leap?(year)}
    end

    def upcoming_years
      (start_time.year..target_time.year).to_a
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

    def days_by_upcoming_years
      upcoming_years.map do |year|
        Date.gregorian_leap?(year) ? 366 : 365
      end
    end

    def days_by_upcoming_months
      upcoming_months.map do |date|
        days_in_month(date)
      end
    end

    def total_days
      days_by_upcoming_months.inject{|sum,x| sum + x }
    end

    def duration
      @__duration ||= calculate_units
    end

    def duration_in_ms
      ((target_time.to_time - start_time.to_time).to_f.round*1000).to_i
    end

    private

    def calculate_units
      rest, millis  = duration_in_ms.divmod(1000)
      rest, seconds = rest.divmod(60)
      rest, minutes = rest.divmod(60)
      days, hours   = rest.divmod(24)

      p :days => days, :total_years => upcoming_years.size, :leap_years => leap_years.size
      p (days % (365+1.0/(upcoming_years.size-1))).round(12)

      # TODO:
      # Using modulo and round does not fit really...
      # Problem (test 'has 1 leap year within 3 years'): 1096 % (365+1.0/3) can never be zero!
      days -= 1 if days != 0 && (days % (365+1.0/(upcoming_years.size-1))).round(12) == 0

      years, days   = days.divmod(365)

      {years: years, months: 0, weeks: 0, days: days, hours: hours, minutes: minutes, seconds: seconds, millis: millis}
    end

  end
end