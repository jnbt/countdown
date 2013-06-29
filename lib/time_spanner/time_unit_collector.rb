module TimeSpanner

  class TimeUnitCollector
    include TimeUnits

    AVAILABLE_UNITS = [:millenniums, :centuries, :decades, :years, :months, :weeks, :days, :hours, :minutes, :seconds, :milliseconds, :microseconds, :nanoseconds]

    attr_reader   :unit_names
    attr_accessor :units

    def initialize(unit_names)
      @unit_names = unit_names
      @units      = []

      validate_unit_names!
      collect!
    end


    private

    def collect!
      unit_names.each do |name|
        units << unit_by_name(name)
      end
    end

    def unit_by_name(name)
      case name
        when :millenniums  then Millennium
        when :centuries    then Century
        when :decades      then Decade
        when :years        then Year
        when :months       then Month
        when :weeks        then Week
        when :days         then Day
        when :hours        then Hour
        when :minutes      then Minute
        when :seconds      then Second
        when :milliseconds then Millisecond
        when :microseconds then Microsecond
        when :nanoseconds  then Nanosecond
      end
    end

    def validate_unit_names!
      unit_names.each do |unit_name|
        raise InvalidUnitError, "Unit '#{unit_name}' is not a valid time unit." unless AVAILABLE_UNITS.include? unit_name
      end
    end

  end

  class InvalidUnitError < StandardError; end

end
