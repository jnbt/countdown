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

    end
  end
end
