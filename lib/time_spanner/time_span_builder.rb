module TimeSpanner

  class TimeSpanBuilder

    DEFAULT_UNITS = TimeUnitCollector::AVAILABLE_UNITS

    attr_reader :unit_names, :unit_chain

    def initialize(from, to, unit_names=[])
      @unit_names = valid_unit_names(unit_names)
      units       = TimeUnitCollector.new(@unit_names).units
      @unit_chain = DurationChain.new(from, to, units)
    end

    def time_span
      @__time_span ||= build
    end

    private

    def build
      unit_container = {}

      unit_chain.each do |unit|
        unit_container[unit.plural_name] = unit.amount
      end
      unit_container
    end

    def valid_unit_names(unit_names)
      !unit_names || unit_names.compact.empty? ? DEFAULT_UNITS : unit_names
    end

  end

end