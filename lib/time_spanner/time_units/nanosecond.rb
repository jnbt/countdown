module TimeSpanner
  module TimeUnits

    class Nanosecond < TimeUnit

      def initialize
        super(13, 1)
      end

      def calculate(duration)
        self.amount = duration
      end

    end
  end

end
