module TimeSpanner
  module TimeUnits

    class Minute < TimeUnit

      def initialize
        super(9, 60000000000)
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
