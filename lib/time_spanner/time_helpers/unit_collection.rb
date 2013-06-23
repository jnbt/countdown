module TimeSpanner
  module TimeHelpers

    class UnitCollection

      DEFAULT_ORDER = [:millenniums, :centuries, :decades, :years, :months, :weeks, :days, :hours, :minutes, :seconds, :millis, :micros, :nanos]

      attr_reader :units

      def initialize(units)
        @units = units
        sort!
      end

      def sort!
        units
      end

    end

  end
end
