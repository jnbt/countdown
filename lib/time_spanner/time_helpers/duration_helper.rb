require 'date'
require 'time'

module TimeSpanner
  module TimeHelpers
    module DurationHelper

      # Returns number of nanoseconds for given time span.
      def self.nanoseconds(from, to)
        p :from => from, :to => to
        ((to.to_time.to_r - from.to_time.to_r).round(9) * 1000000000).to_i
      end

      # Returns number of days for given time span.
      def self.days(from, to)
        (to.to_time - from.to_time).to_i / 86400
      end

      # Returns number of months for given time span.
      # Substract 1 from months if to's day is smaller than from's day
      # Reason: It should be 3 months and 20 days and not 4 months!
      def self.months(from, to)
        (to.year*12 + to.month) - (from.year*12 + from.month) - (to.day < from.day ? 1 : 0)
      end

      def self.weeks_with_rest(from, to)
        days = to.to_datetime - from.to_datetime
        weeks = (days / 7).to_i

        from_with_weeks = from.to_datetime + weeks*7
        rest = nanoseconds(from_with_weeks, to)

        [weeks, rest]
      end

      def self.months_with_rest(from, to)
        months = months(from, to)

        from_with_months = from.to_datetime >> months
        rest = nanoseconds(from_with_months, to)

        [months, rest]
      end

      def self.decades_with_rest(from, to)
        decades = (to.year - from.year) / 10

        from_with_decades = from.to_datetime >> decades*120
        rest = nanoseconds(from_with_decades, to)

        [decades, rest]
      end

      def self.centuries_with_rest(from, to)
        centuries = (to.year - from.year) / 100

        from_with_centuries = from.to_datetime >> centuries*1200
        rest = nanoseconds(from_with_centuries, to)

        [centuries, rest]
      end

      def self.years_with_rest(from, to)
        years = (to.year - from.year)

        from_with_years = from.to_datetime >> years*12
        p :from_with_years => from_with_years
        rest = nanoseconds(from_with_years, to)

        [years, rest]
      end

      def self.millenniums_with_rest(from, to)
        millenniums = (to.year - from.year) / 1000

        from_with_millenniums = from.to_datetime >> millenniums*12000
        p :from_with_millenniums => from_with_millenniums
        rest = nanoseconds(from_with_millenniums, to)

        [millenniums, rest]
      end

      # Returns Array with number of months and remaining days for given time span.
      def self.months_with_days(from, to)
        months = months from, to
        days   = (to.to_date - (from.to_date >> months)).to_i #remaining_days (without the 2 months)

        [months, days]
      end

    end
  end
end
