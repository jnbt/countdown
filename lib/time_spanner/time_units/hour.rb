module TimeSpanner
  module TimeUnits

    class Hour < TimeUnit

      alias :minutes :rest

      def initialize(name)
        super name
        @position = 8
      end

      def calculate(nanos)
        rest, nanos   = nanos.divmod(1000)
        rest, micros  = rest.divmod(1000)
        rest, millis  = rest.divmod(1000)
        minutes, seconds = rest.divmod(60)

        self.amount, self.rest = minutes.divmod(60)
      end

    end
  end

end
