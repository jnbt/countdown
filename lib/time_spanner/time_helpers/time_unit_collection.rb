require 'time_spanner/time_helpers'

module TimeSpanner
  module TimeHelpers

    class TimeUnitCollection
      include Enumerable

      AVAILABLE_UNITS = [:millenniums, :centuries, :decades, :years, :months, :weeks, :days, :hours, :minutes, :seconds, :millis, :micros, :nanos]
      DEFAULT_ORDER = AVAILABLE_UNITS

      attr_reader :units

      def initialize(unit_names)
        @units = unit_names.map {|name| TimeUnit.new(name) }
      end

      def each
        units.each do |unit|
          yield unit
        end
      end

    end

    class TimeUnit
      include Comparable

      DEFAULT_ORDER = TimeUnitCollection::DEFAULT_ORDER

      attr_reader :name

      def initialize(name)
        @name = name
      end

      def <=>(other)
        DEFAULT_ORDER.index(name) <=> DEFAULT_ORDER.index(other.name)
      end

    end

  end
end
