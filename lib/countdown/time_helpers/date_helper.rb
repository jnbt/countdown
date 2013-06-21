require 'date'
require 'time'

module Countdown
  module TimeHelpers
    module DateHelper

      VALID_DATE_CLASSES        = ["Date", "DateTime", "Time"]
      COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

      def self.to_first_day(time)
        preserve_time_class time, Date.new(time.year, time.month, 1)
      end

      def self.to_last_day(time)
        year  = time.year
        month = time.month
        day = if month == 2 && leap?(year)
                29
              else
                COMMON_YEAR_DAYS_IN_MONTH[month]
              end

        self.preserve_time_class time, Date.new(year, month, day)
      end

      def self.last_day(time)
        to_last_day(time).day
      end

      def self.leap_years(from, to)
        leap_years = (from.year..to.year).to_a.select{|year| leap?(year)}

        leap_years.shift if leap?(from.year) && from.to_time >= Date.new(from.year, 2, 29).to_time # starting_time >= 2012-02-29 has no leap days (after February 29th!)
        leap_years.pop if leap?(to.year) && to.to_time < Date.new(to.year, 2, 28).to_time # target_time <= 2012-02-28 has no leap days (before February 29th!)

        leap_years
      end

      def self.leap?(year)
        Date.gregorian_leap?(year)
      end

      def self.leaps(from, to)
        leap_years(from, to).size
      end

      def self.preserve_time_class(initial_time, new_time)
        unless [initial_time, new_time].any? { |time| VALID_DATE_CLASSES.include? time.class.name }
          raise "Invalid class given. Allowed: #{VALID_DATE_CLASSES}"
        end

        case initial_time.class
          when Time
            new_time.to_time

          when DateTime
            new_time.to_datetime

          else # Date
            new_time.to_date
        end
      end
    end

  end
end