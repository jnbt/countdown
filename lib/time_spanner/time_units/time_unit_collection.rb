module TimeSpanner
  module TimeUnits

    class TimeUnitCollection
      include Enumerable

      AVAILABLE_UNITS = [:millenniums, :centuries, :decades, :years, :months, :weeks, :days, :hours, :minutes, :seconds, :millis, :micros, :nanos]
      DEFAULT_ORDER = AVAILABLE_UNITS

      attr_accessor :units
      attr_reader :duration

      def initialize(duration)
        @duration = duration
        @units = []
      end

      def <<(unit)
        units << unit
      end

      def each
        units.each do |unit|
          yield unit
        end
      end

      def sort!
        self.units = units.sort
      end

      def identifier
        units.map(&:name).join('_').to_sym
      end

      # Does not work yet
      def calculate
        rest = duration
        each do |unit|
          unit.calculate(rest)
          rest = unit.rest
        end
      end

    end

  end
end
