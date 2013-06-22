require 'date'
require 'time'
require 'time_spanner/time_helpers/date_helper'
require 'time_spanner/time_helpers/duration_helper'

module TimeSpanner
  module TimeHelpers

    class TimeSpan

      DEFAULT_UNITS = [:millenniums, :centuries, :decades, :years, :months, :weeks, :days, :hours, :minutes, :seconds, :millis, :nanos]

      attr_reader :from, :to

      attr_reader :nanos
      attr_reader :micros
      attr_reader :millis
      attr_reader :seconds
      attr_reader :minutes
      attr_reader :hours
      attr_reader :days
      attr_reader :weeks
      attr_reader :months
      attr_reader :years
      attr_reader :decades
      attr_reader :centuries
      attr_reader :millenniums

      def initialize(from, to, *args)
        @from  = from
        @to    = to
        @units = args || DEFAULT_UNITS

        calculate
      end

      def total_nanos
        (duration.round(9) * 1000000000).to_i
      end

      def total_micros
        total_nanos / 1000
      end

      def total_millis
        total_micros / 1000
      end

      def total_seconds
        total_millis / 1000
      end

      def total_minutes
        total_seconds / 60
      end

      def total_hours
        total_minutes / 60
      end

      def total_days
        total_hours / 24 - leaps
      end

      def total_weeks
        (total_days + leaps) / 7
      end

      def total_months
        DurationHelper.months from, to
      end

      def calculate
        remaining_micros, @nanos    = total_nanos.divmod(1000)
        remaining_millis, @micros   = remaining_micros.divmod(1000)
        remaining_seconds, @millis  = remaining_millis.divmod(1000)
        remaining_minutes, @seconds = remaining_seconds.divmod(60)
        remaining_hours, @minutes   = remaining_minutes.divmod(60)
        remaining_days, @hours      = remaining_hours.divmod(24)

        remaining_days -= leaps

        remaining_years, remaining_days = remaining_days.divmod(365)

        @months, days = TimeSpan.months_and_days(to.to_date-remaining_days, to)

        remaining_decades, @years     = remaining_years.divmod(10)
        remaining_centuries, @decades = remaining_decades.divmod(10)
        @millenniums, @centuries      = remaining_centuries.divmod(10)

        @weeks, @days  = days.divmod(7)
      end

      def duration
        to.to_time.to_r - from.to_time.to_r
      end

      # Calculate remaining days for given timeframe
      def self.days_in_timeframe(from, to)
        from = from.to_date
        to   = to.to_date

        # fetch months from start_date to end_date as Date objects
        month_dates = []

        DateHelper.to_first_day(from).upto(DateHelper.to_first_day(to)) do |date|
          month_dates << date if date.day == 1
        end

        month_dates.shift # remove first date; will be added afterwards
        month_dates.pop   # remove last date; will be added afterwards

                                                                              # add first date's actual days difference to month's max-days
        days_by_upcoming_months = [ DateHelper.last_day(from) - from.day ]

        if to.day == from.day
          days_by_upcoming_months << to.day
        else
          days_by_upcoming_months << 1 # +1 because the first day of start_date needs to added aswell
        end

        month_dates.each { |date| days_by_upcoming_months << DateHelper.last_day(date) } # fetch max-days for all remaining months

        days_by_upcoming_months.inject { |sum, x| sum + x }
      end

      def self.months_and_days(from, to)
        months = DurationHelper.months(from, to)

        return [0, to.to_date - from.to_date] if months == 0 # no day calculation needed since we have less days than 1 month has

        days = (to.to_date - from.to_date) - days_in_timeframe(from, to) # substract days for all months from remaining_days

        [months, days]
      end

      private

      def leaps
        DateHelper.leap_count from, to
      end

    end
  end

end