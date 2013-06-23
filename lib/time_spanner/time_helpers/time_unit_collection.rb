module TimeSpanner
  module TimeHelpers

    class TimeUnitCollection
      include Enumerable

      AVAILABLE_UNITS = [:millenniums, :centuries, :decades, :years, :months, :weeks, :days, :hours, :minutes, :seconds, :millis, :micros, :nanos]
      DEFAULT_ORDER = AVAILABLE_UNITS

      attr_accessor :units

      def initialize
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

    end

    class TimeUnit
      include Comparable

      DEFAULT_ORDER = TimeUnitCollection::DEFAULT_ORDER

      attr_reader :name, :position, :duration

      def initialize(name, duration=nil)
        @duration = duration
        @position = 1
        @name = name
      end

      def amount
        @duration / 24 # If this is an hour
      end

      def <=>(other)
        DEFAULT_ORDER.index(name) <=> DEFAULT_ORDER.index(other.name)
      end

    end

  end
end
