module TimeSpanner
  module TimeUnits

    class Nanosecond < TimeUnit

      MULTIPLIER = 1

      def initialize
        super 13
      end

      def calculate(duration)
        self.amount = duration
      end

    end
  end

end
