require 'date'
require 'time'

module TimeSpanner
  module TimeHelpers
    module DurationHelper

      # Returns number of months for given time span.
      # Substract 1 from months if to's day is smaller than from's day
      # Reason: It should be 3 months and 20 days and not 4 months!
      def self.months(from, to)
        (to.year*12 + to.month) - (from.year*12 + from.month) - (to.day < from.day ? 1 : 0)
      end

      # Returns Array with number of months and remaining days for given time span.
      def self.months_with_days(from, to)
        months = months from, to
        days  = (to.to_date - (from.to_date >> months)).to_i #remaining_days (without the 2 months)
        [months, days]
      end

    end
  end
end
