require 'time_spanner/time_helpers/time_span'

module TimeSpanner

  class TimeSpanBuilder
    include TimeSpanner::TimeHelpers

    DEFAULT_UNITS = TimeSpan::DEFAULT_UNITS

    attr_reader :units, :reverse, :start_time, :target_time, :duration

    def initialize(start_time, target_time, time_units=[])
      @reverse        = target_time < start_time
      @start_time     = reverse ? target_time : start_time
      @target_time    = reverse ? start_time : target_time
      @units          = set_units(time_units)

      validate_units!
      @duration = TimeSpan.new(@start_time, @target_time, units) # Interesting: if I use attr_readers for start- and target time nano-calculation is inaccurate!
    end

    def time_span
      @__time_span ||= build
    end

    private

    def build
      unit_container = {}

      units.each do |unit|
        value_for_unit = duration.instance_variable_get(:"@#{unit}")
        unit_container[unit] = reverse? ? -value_for_unit : value_for_unit
      end
      unit_container
    end

    # Countdown with negative values because target_time is before start_time.
    def reverse?
      reverse
    end

    def set_units(units)
      !units || units.empty? ? DEFAULT_UNITS : units
    end

    def validate_units!
      units.each do |unit|
        raise InvalidUnitError, "Unit '#{unit}' is not a valid time unit." unless TimeSpan::AVAILABLE_UNITS.include? unit
      end
    end

  end

  class InvalidUnitError < StandardError; end
end