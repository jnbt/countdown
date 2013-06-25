module TimeSpanner
  module TimeUnits

    class Second < TimeUnit

      MULTIPLIER = 1000000000

      def initialize
        super 10, MULTIPLIER
      end

    end
  end

end
