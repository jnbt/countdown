module TimeSpanner
  module TimeUnits

    class Minute < TimeUnit

      MULTIPLIER = Rational(1, 60)

      def initialize
        super 9, MULTIPLIER
      end

    end
  end

end
