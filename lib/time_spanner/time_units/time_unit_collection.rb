module TimeSpanner
  module TimeUnits

    class TimeUnitCollection
      include Enumerable

      AVAILABLE_UNITS = [:millenniums, :centuries, :decades, :years, :months, :weeks, :days, :hours, :minutes, :seconds, :milliseconds, :microseconds, :nanoseconds]
      DEFAULT_ORDER   = AVAILABLE_UNITS

      attr_accessor :units
      attr_reader   :duration, :unit_names

      def initialize(duration, unit_names)
        @duration   = duration
        @unit_names = unit_names
        @units      = []

        add_units_by_names
        sort!
        calculate
      end

      def add_units_by_names
        unit_names.each do |name|
          add unit_by_name(name)
        end
      end

      def unit_by_name(name)
        class_name = name.to_s.capitalize.chop # will not work on :centuries
        TimeUnits.const_get(class_name).new if TimeUnits.const_defined?(class_name)
      end

      def add(unit)
        self.units << unit if unit
      end

      def each
        units.each do |unit|
          yield unit
        end
      end

      def sort!
        self.units = units.sort
      end

      def calculate
        rest = duration
        each do |unit|
          unit.calculate(rest)
          rest = unit.rest
        end
      end

      # TODO: remove
      def identifier
        unit_names.join('_').to_sym
        #units.map(&:name).join('_').to_sym
      end

    end

  end
end
