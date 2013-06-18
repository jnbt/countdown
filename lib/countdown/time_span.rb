require 'date'

module Countdown
  class TimeSpan

    COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    attr_reader :start_time, :target_time, :duration_in_nanos, :millenniums, :centuries, :decades, :years, :months, :weeks, :days, :hours, :minutes, :seconds, :millis, :micros, :nanos

    def initialize(start_time, target_time)
      @start_time     = start_time
      @target_time    = target_time
      @duration_in_nanos = duration_in_nanos
      @millenniums    = duration[:millenniums]
      @centuries      = duration[:centuries]
      @decades        = duration[:decades]
      @years          = duration[:years]
      @months         = duration[:months]
      @weeks          = duration[:weeks]
      @days           = duration[:days]
      @hours          = duration[:hours]
      @minutes        = duration[:minutes]
      @seconds        = duration[:seconds]
      @millis         = duration[:millis]
      @micros         = duration[:micros]
      @nanos          = duration[:nanos]
    end

    def [](unit)
      send unit
    end

    def duration
      @__duration ||= calculate_units
    end

    def duration_in_nanos
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

    private

    def calculate_units
      micros, nanos    = duration_in_nanos.divmod(1000)
      millis, micros   = micros.divmod(1000)
      seconds, millis  = millis.divmod(1000)
      minutes, seconds = seconds.divmod(60)
      hours, minutes   = minutes.divmod(60)
      days, hours      = hours.divmod(24)

      days -= leap_count

      years, days             = days.divmod(365)
      decades, years          = years.divmod(10)
      centuries, decades      = decades.divmod(10)
      millenniums, centuries  = centuries.divmod(10)

      # todo: months

      weeks, days  = days.divmod(7)

      {millenniums: millenniums, centuries: centuries, decades: decades, years: years, months: 0, weeks: weeks, days: days, hours: hours, minutes: minutes, seconds: seconds, millis: millis, micros: micros, nanos: nanos}
    end

    def leap?(year)
      Date.gregorian_leap?(year)
    end

  end
end