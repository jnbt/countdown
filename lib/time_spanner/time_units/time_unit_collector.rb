module TimeSpanner
  module TimeUnits

    class TimeUnitCollector
      include TimeHelpers

      AVAILABLE_UNITS = [:millenniums, :centuries, :decades, :years, :months, :weeks, :days, :hours, :minutes, :seconds, :milliseconds, :microseconds, :nanoseconds]

      attr_accessor :units
      attr_reader   :unit_names, :from, :to, :duration_chain

      def initialize(from, to, unit_names)
        @from       = from
        @to         = to
        @unit_names = unit_names
        @units      = []

        validate_unit_names!
        add_units_by_names
        @units = DurationChain.new(from, to, units).units
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
          when :months       then Month.new(from, to)
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

      # TODO: remove
      def identifier
        unit_names.join('_').to_sym
      end

      private

      def validate_unit_names!
        unit_names.each do |unit_name|
          raise InvalidUnitError, "Unit '#{unit_name}' is not a valid time unit." unless AVAILABLE_UNITS.include? unit_name
        end
      end

    end

    class InvalidUnitError < StandardError; end

  end
end
