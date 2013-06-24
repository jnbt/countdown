module TimeSpanner
  module TimeUnits

    class Millisecond < TimeUnit

      def initialize
        super(11, 1000000)
      end

      def calculate(duration)
        nanoseconds, rest = duration.divmod(1000)
        self.amount, rest = nanoseconds.divmod(1000)

        calculate_rest(duration)
      end

    end
  end

end
