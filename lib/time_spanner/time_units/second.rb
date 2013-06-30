module TimeSpanner
  module TimeUnits

    class Second < TimeUnit

      MULTIPLIER = 1

      def initialize
        super 10, MULTIPLIER
      end

    end
  end

end
