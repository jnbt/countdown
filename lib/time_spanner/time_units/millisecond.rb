module TimeSpanner
  module TimeUnits

    class Millisecond < TimeUnit

      MULTIPLIER = 1000000

      def initialize
        super 11
      end

      def calculate(duration)
        nanoseconds, rest = duration.divmod(1000)
        self.amount, rest = nanoseconds.divmod(1000)

        calculate_rest(duration)
      end

    end
  end

end
