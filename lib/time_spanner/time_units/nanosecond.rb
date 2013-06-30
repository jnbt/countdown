module TimeSpanner
  module TimeUnits

    class Nanosecond < TimeUnit

      MULTIPLIER = 1000000000

      def initialize
        super 13, MULTIPLIER
      end

    end

  end
end
