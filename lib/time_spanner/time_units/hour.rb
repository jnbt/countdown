module TimeSpanner
  module TimeUnits

    class Hour < TimeUnit

      def initialize(name)
        super name
        @position = 8
      end

      def calculate(duration)
        rest, nanos   = duration.divmod(1000)
        rest, micros  = rest.divmod(1000)
        rest, millis  = rest.divmod(1000)
        minutes, seconds = rest.divmod(60)

        self.amount, rest = minutes.divmod(60)
        self.rest = calculate_rest(duration)
      end

      private

      def calculate_rest(nanos)
        nanos - amount_to_nanos
      end

      def amount_to_nanos
        self.amount * 3600000000000
      end

    end
  end

end
