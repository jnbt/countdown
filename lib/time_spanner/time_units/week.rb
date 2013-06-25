module TimeSpanner
  module TimeUnits

    class Week < TimeUnit

      def initialize
        super(6, 604800000000000)
      end

      def calculate(duration)
        rest, nanoseconds  = duration.divmod(1000)
        rest, microseconds = rest.divmod(1000)
        rest, milliseconds = rest.divmod(1000)
        rest, seconds      = rest.divmod(60)
        rest, minutes      = rest.divmod(60)
        rest, hours        = rest.divmod(24)
        self.amount, rest  = rest.divmod(7)

        calculate_rest(duration)
      end

    end

  end
end
