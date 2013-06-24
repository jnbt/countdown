module TimeSpanner
  module TimeUnits

    class Second < TimeUnit

      def initialize
        super(10, 1000000000)
      end

      def calculate(duration)
        nanoseconds, rest = duration.divmod(1000)
        microseconds, rest = duration.divmod(1000)
        milliseconds, rest = microseconds.divmod(1000)
        self.amount, rest = milliseconds.divmod(1000)

        calculate_rest(duration)
      end

    end
  end

end
