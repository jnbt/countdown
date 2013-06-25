module TimeSpanner
  module TimeUnits

    class DurationChain
      include TimeHelpers

      attr_reader :units, :duration

      def initialize(from, to, units)
        @duration = DurationHelper.nanoseconds(from, to)
        @units    = units

        calculate!
      end

      # Perform duration calculations for units in chain.
      def calculate!
        nanoseconds = duration

        units.each do |unit|
          unit.calculate(nanoseconds)
          nanoseconds = unit.rest
        end
      end

    end
  end

end
