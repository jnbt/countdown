module TimeSpanner
  module TimeUnits

    class Minutes < TimeUnit

      def initialize
        super
        @position = 9
      end

      def calculate(duration)
        rest, nanoseconds    = duration.divmod(1000)
        rest, microseconds   = rest.divmod(1000)
        seconds, milliseconds = rest.divmod(1000)

        self.amount, rest = seconds.divmod(60)
        self.rest = calculate_rest(duration)
      end

      private

      def calculate_rest(nanoseconds)
        nanoseconds - amount_to_nanoseconds
      end

      def amount_to_nanoseconds
        self.amount * 60000000000
      end

    end
  end

end
