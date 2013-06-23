module TimeSpanner
  module TimeUnits

    class Minute < TimeUnit

      alias :seconds :rest

      def initialize(name)
        super name
        @position = 9
      end

      def calculate(nanos)
        rest, nanos    = nanos.divmod(1000)
        rest, micros   = rest.divmod(1000)
        seconds, millis = rest.divmod(1000)

        self.amount, self.rest = seconds.divmod(60)
      end

    end
  end

end
