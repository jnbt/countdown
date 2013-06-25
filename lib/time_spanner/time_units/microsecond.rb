module TimeSpanner
  module TimeUnits

    class Microsecond < TimeUnit

      MULTIPLIER = 1000

      def initialize
        super 12
      end

      def calculate(duration)
        self.amount, rest = duration.divmod(1000)

        calculate_rest(duration)
      end

    end
  end

end
