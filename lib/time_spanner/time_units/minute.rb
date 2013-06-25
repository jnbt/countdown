module TimeSpanner
  module TimeUnits

    class Minute < TimeUnit

      MULTIPLIER = 60000000000

      def initialize
        super 9, MULTIPLIER
      end

    end
  end

end
