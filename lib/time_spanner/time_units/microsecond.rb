module TimeSpanner
  module TimeUnits

    class Microsecond < TimeUnit

      def initialize
        super(12, 1000)
      end

      def calculate(duration)
        self.amount, rest = duration.divmod(1000)

        calculate_rest(duration)
      end

    end
  end

end
