module TimeSpanner
  module TimeUnits

    class Hour < TimeUnit

      def initialize
        super(8, 3600000000000)
      end

      def calculate(duration)
        rest, nanoseconds   = duration.divmod(1000)
        rest, microseconds  = rest.divmod(1000)
        rest, milliseconds  = rest.divmod(1000)
        minutes, seconds    = rest.divmod(60)
        self.amount, rest   = minutes.divmod(60)

        calculate_rest(duration)
      end

    end
  end

end
