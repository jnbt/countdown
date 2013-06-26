module TimeSpanner
  module TimeUnits

    class Day < TimeUnit

      MULTIPLIER = 86400000000000

      attr_accessor :from

      def initialize
        super 7, MULTIPLIER
      end

      def calculate(from, to)
        self.amount = days_without_leap_days(from, to)
        self.from   = from.to_datetime >> amount

        calculate_rest(total_nanoseconds(from, to) - leap_days_in_nanos(from, to))
      end


      private

      def days(from, to)
        DurationHelper.days(from, to)
      end

      def total_nanoseconds(from, to)
        DurationHelper.nanoseconds(from, to)
      end

      def days_without_leap_days(from, to)
        days(from, to) - leap_days(from, to)
      end

      def leap_days_in_nanos(from, to)
        leap_days(from, to) * multiplier
      end

      def leap_days(from, to)
        @__leap_days ||= DateHelper.leap_count(from, to)
      end

    end

  end
end
