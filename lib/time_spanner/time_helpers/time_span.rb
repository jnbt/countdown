require 'date'
require 'time'
require 'time_spanner/time_helpers/date_helper'

module TimeSpanner
  module TimeHelpers

    class TimeSpan

      attr_reader :from, :to

      def initialize(from, to)
        @from = from
        @to   = to
      end

      def nanos
        (to.to_time.to_r - from.to_time.to_r).round(9) * 1000000000
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

      # Return Array with months and remaining days given a target date and remaining_days to it
      # remaining_days must be within 0 and 364
      # TODO: better supply a from time instead of remaining_days
      def self.months_and_days(to, remaining_days)
        #TODO: all we should do here is return: [months_in_timeframe, days_in_timeframe]
        # Months calculation:

        target_date  = to
        current_date = target_date.to_time - remaining_days * 86400 #TODO: Time.at(target_date.to_time - from.to_seconds)

        months = (target_date.year * 12 + target_date.month) - (current_date.year * 12 + current_date.month) #TODO: own method to calculate months

        # in order to make this example work: "2013-02-10 00:00:00" to "2013-06-02 00:00:00"
        # we need to substract 1 from months if target_date's day is smaller than current_date's day
        # It should be 3 months and 20 days and not 4 months!
        months -= 1 if target_date.day < current_date.day

        return [0, remaining_days] if months == 0 # no day calculation needed since we have less days than 1 month has

        # Days calculation: #TODO: own method to calculate days

        days = remaining_days - days_in_timeframe(current_date, target_date) # substract days for all months from remaining_days

        [months, days]
      end

    end
  end

end