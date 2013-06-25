module TimeSpanner
  module TimeUnits

    class Day < TimeUnit

      def initialize
        super(7, 86400000000000)
      end

      def calculate(from, to)
        leap_days   = DateHelper.leap_count(from, to)
        self.amount = DurationHelper.days(from, to) - leap_days

        calculate_rest(DurationHelper.nanoseconds(from, to) - leap_days * nano_multiplier)
      end

    end

  end
end
