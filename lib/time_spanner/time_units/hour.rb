module TimeSpanner
  module TimeUnits

    class Hour < TimeUnit

      MULTIPLIER = Rational(1, 3600)

      def initialize
        super 8, MULTIPLIER
      end

    end
  end

end
