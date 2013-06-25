module TimeSpanner
  module TimeUnits

    class Week < TimeUnit

      MULTIPLIER = 604800000000000

      def initialize
        super 6, MULTIPLIER
      end

    end

  end
end
