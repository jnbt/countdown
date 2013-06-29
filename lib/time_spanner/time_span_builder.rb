module TimeSpanner

  class TimeSpanBuilder

    DEFAULT_UNITS = TimeUnitCollector::AVAILABLE_UNITS

    attr_reader :start_time, :target_time, :unit_names, :units, :reverse

    def initialize(start_time, target_time, unit_names=[])
      @reverse     = target_time < start_time
      @start_time  = reverse ? target_time : start_time
      @target_time = reverse ? start_time : target_time

      @unit_names  = valid_unit_names(unit_names)
      @units       = TimeUnitCollector.new(@start_time, @target_time, @unit_names).units
    end

    def time_span
      @__time_span ||= build
    end

    private

    def build
      unit_container = {}

      units.each do |unit|
        unit_container[unit.plural_name] = reverse? ? -unit.amount : unit.amount
      end
      unit_container
    end

    # Countdown with negative values because target_time is before start_time.
    def reverse?
      reverse
    end

    def valid_unit_names(unit_names)
      !unit_names || unit_names.compact.empty? ? DEFAULT_UNITS : unit_names
    end

  end

end