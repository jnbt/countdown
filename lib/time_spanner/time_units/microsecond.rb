module TimeSpanner
  module TimeUnits

    class Microsecond < TimeUnit

      MULTIPLIER = 1000

      def initialize
        super 12, MULTIPLIER
      end

    end
  end

end
