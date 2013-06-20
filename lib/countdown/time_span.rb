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
      @start_time        = (reverse ? target_time : start_time).to_time
      @target_time       = (reverse ? start_time : target_time).to_time

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
      (target_time.to_r - start_time.to_r).round(9) * 1000000000
    end

    def leap_years
      leap_years = (start_time.year..target_time.year).to_a.select{|year| leap?(year)}

      leap_years.shift if leap?(start_time.year) && start_time >= Date.new(start_time.year, 2, 29).to_time # starting_time >= 2012-02-29 has no leap days (after February 29th!)
      leap_years.pop if leap?(target_time.year) && target_time < Date.new(target_time.year, 2, 28).to_time # target_time <= 2012-02-28 has no leap days (before February 29th!)

      leap_years
    end

    def leap_count
      leap_years.size
    end

    def days_in_month(date)
      month = date.month
      return 29 if month == 2 && leap?(date.year)
      COMMON_YEAR_DAYS_IN_MONTH[month]
    end

    def first_day_in_month(date)
      Date.new(date.year, date.month, 1)
    end

    # Return an Array with number of days left for each month
    def days_by_upcoming_months(start_date, end_date)
      # fetch months from start_date to end_date as Date objects
      month_dates = []
      first_day_in_month(start_date).upto(first_day_in_month(end_date)) do |date|
        month_dates << date if date.day == 1
      end

      month_dates.shift # remove first date; will be added afterwards
      month_dates.pop   # remove last date; will be added afterwards

      # add first date's actual days difference to month's max-days
      days_by_upcoming_months = [ days_in_month(start_date) - start_date.day ]

      if end_date.day == start_date.day
        days_by_upcoming_months << end_date.day
      else
        days_by_upcoming_months << 1 # +1 because the first day of start_date needs to added aswell
      end

      month_dates.each { |date| days_by_upcoming_months << days_in_month(date) } # fetch max-days for all remaining months

      days_by_upcoming_months
    end

    # Return Array with months and remaining days
    # remaining_days can be 0 to 364
    # create current time: @target_time - remaining_days
    # make new timeframe start_time -> target_time
    # count months
    # iterate over months
    def days_to_months_and_days(remaining_days)
      # Months calculation:

      target_date  = target_time
      current_date = target_date.to_time - remaining_days * 86400

      months = (target_date.year * 12 + target_date.month) - (current_date.year * 12 + current_date.month)

      # in order to make this example work: "2013-02-10 00:00:00" to "2013-06-02 00:00:00"
      # we need to substract 1 from months if target_date's day is smaller than current_date's day
      # It should be 3 months and 20 days and not 4 months!
      months -= 1 if target_date.day < current_date.day

      return [0, remaining_days] if months == 0 # no day calculation needed since we have less days than 1 month has

      # Days calculation:

      days_by_upcoming_months = days_by_upcoming_months(current_date, target_date).inject { |sum, x| sum + x }

      days = remaining_days - days_by_upcoming_months # substract days for all months from remaining_days

      [months, days]
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

      remaining_years, remaining_days = remaining_days.divmod(365)

      @months, days = days_to_months_and_days(remaining_days)

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