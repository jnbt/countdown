require 'date'
require 'time'

module TimeSpanner
  module TimeHelpers
    module DurationHelper

      # Returns number of nanoseconds for given time span.
      def self.nanoseconds(from, to)
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

      def self.months_with_rest(from, to)
        total  = nanoseconds(from, to)
        months = months(from, to)

        rest_from_in_nanos = nanoseconds(from.to_date.to_datetime, from)
        month_end          = (from.to_date >> months).to_datetime
        months_in_nanos    = nanoseconds(from, month_end) + rest_from_in_nanos

        rest = total - months_in_nanos
        [months, rest]
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
