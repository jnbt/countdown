module TimeSpanner
  module TimeUnits

    class TimeUnitCollection
      include Enumerable

      AVAILABLE_UNITS = [:millenniums, :centuries, :decades, :years, :months, :weeks, :days, :hours, :minutes, :seconds, :milliseconds, :microseconds, :nanoseconds]
      DEFAULT_ORDER   = AVAILABLE_UNITS

      attr_accessor :units
      attr_reader   :duration, :unit_names, :from, :to

      def initialize(from, to, duration, unit_names)
        @from       = from
        @to         = to
        @duration   = duration
        @unit_names = unit_names
        @units      = []

        add_units_by_names
        calculate
      end

      def add_units_by_names
        unit_names.each do |name|
          add unit_by_name(name)
        end
      end

      def unit_by_name(name)
        case name
          #when :millenniums then Millenium.new
          #when :centuries then Century.new
          #when :decades then Decade.new
          #when :years then Year.new
          #when :months then Month.new
          #when :weeks then Week.new
          when :days         then Day.new(from, to)
          when :hours        then Hour.new
          when :minutes      then Minute.new
          when :seconds      then Second.new
          when :milliseconds then Millisecond.new
          when :microseconds then Microsecond.new
          when :nanoseconds  then Nanosecond.new
        end
      end

      def add(unit)
        self.units << unit if unit
      end

      def each
        units.each do |unit|
          yield unit
        end
      end

      # Units must be sorted to be able to perform a calculation chain.
      def sort!
        self.units = units.sort
      end

      # Calculate units in chain.
      def calculate
        sort!
        rest = duration
        each do |unit|
          unit.calculate(rest)
          rest = unit.rest
        end
      end

      # TODO: remove
      def identifier
        unit_names.join('_').to_sym
      end

    end

  end
end
