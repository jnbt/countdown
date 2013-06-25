module TimeSpanner
  module TimeUnits

    class Hour < TimeUnit

      MULTIPLIER = 3600000000000

      def initialize
        super 8, MULTIPLIER
      end

    end
  end

end
