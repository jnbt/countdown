module TimeSpanner

  class TimeUnitCollector
    include TimeUnits

    AVAILABLE_UNITS = [:millenniums, :centuries, :decades, :years, :months, :weeks, :days, :hours, :minutes, :seconds, :milliseconds, :microseconds, :nanoseconds]

    attr_reader   :unit_names, :duration_chain
    attr_accessor :units

    def initialize(from, to, unit_names)
      @duration_chain = DurationChain.new(from, to)
      @unit_names     = unit_names

      validate_unit_names!
      calculate_units!
    end


    private

    def calculate_units!
      unit_names.each do |name|
        duration_chain << unit_by_name(name)
      end

      duration_chain.calculate!
      self.units = duration_chain.units
    end

    def unit_by_name(name)
      case name
        when :millenniums  then Millennium.new
        when :centuries    then Century.new
        when :decades      then Decade.new
        when :years        then Year.new
        when :months       then Month.new
        when :weeks        then Week.new
        when :days         then Day.new
        when :hours        then Hour.new
        when :minutes      then Minute.new
        when :seconds      then Second.new
        when :milliseconds then Millisecond.new
        when :microseconds then Microsecond.new
        when :nanoseconds  then Nanosecond.new
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
