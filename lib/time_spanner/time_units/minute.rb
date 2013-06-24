module TimeSpanner
  module TimeUnits

    class Minute < TimeUnit

      alias :seconds :rest

      def initialize(name)
        super name
        @position = 9
      end

      def calculate(duration)
        rest, nanos    = duration.divmod(1000)
        rest, micros   = rest.divmod(1000)
        seconds, millis = rest.divmod(1000)

        self.amount, rest = seconds.divmod(60)
        self.rest = calculate_rest(duration)
      end

      private

      def calculate_rest(nanos)
        nanos - amount_to_nanos
      end

      def amount_to_nanos
        self.amount * 60000000000
      end

    end
  end

end
