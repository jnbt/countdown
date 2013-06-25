module TimeSpanner
  module TimeUnits

    class TimeUnitCollection
      include Enumerable
      include TimeHelpers

      AVAILABLE_UNITS = [:millenniums, :centuries, :decades, :years, :months, :weeks, :days, :hours, :minutes, :seconds, :milliseconds, :microseconds, :nanoseconds]
      DEFAULT_ORDER   = AVAILABLE_UNITS

      attr_accessor :units
      attr_reader   :duration, :unit_names, :from, :to

      def initialize(from, to, unit_names)
        @from       = from
        @to         = to
        @unit_names = unit_names
        @units      = []

        @total_nanoseconds = total_nanoseconds


        add_units_by_names
        calculate
      end

      def total_nanoseconds
        DurationHelper.nanoseconds(from, to)
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
          #when :months       then Month.new
          when :weeks        then Week.new
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
      # TODO: use Duration::Nanoseconds.new(from, to) and remove 'total_nanoseconds' and 'duration' method
      #
      def calculate
        sort!
        rest = total_nanoseconds
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
