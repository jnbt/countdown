module TimeSpanner
  module TimeUnits

    class Hours < TimeUnit

      def initialize
        super
        @position = 8
      end

      def calculate(duration)
        rest, nanoseconds   = duration.divmod(1000)
        rest, microseconds  = rest.divmod(1000)
        rest, milliseconds  = rest.divmod(1000)
        minutes, seconds = rest.divmod(60)

        self.amount, rest = minutes.divmod(60)
        self.rest = calculate_rest(duration)
      end

      private

      def calculate_rest(nanoseconds)
        nanoseconds - amount_to_nanoseconds
      end

      def amount_to_nanoseconds
        self.amount * 3600000000000
      end

    end
  end

end
