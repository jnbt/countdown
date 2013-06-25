module TimeSpanner
  module TimeUnits

    class Minute < TimeUnit

      MULTIPLIER = 60000000000

      def initialize
        super 9
      end

      def calculate(duration)
        rest, nanoseconds     = duration.divmod(1000)
        rest, microseconds    = rest.divmod(1000)
        seconds, milliseconds = rest.divmod(1000)
        self.amount, rest     = seconds.divmod(60)

        calculate_rest(duration)
      end

    end
  end

end
