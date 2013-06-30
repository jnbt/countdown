module TimeSpanner

  class TimeSpanBuilder

    attr_reader :unit_chain

    def initialize(from, to, unit_names=[])
      units       = TimeUnitCollector.new(unit_names).units
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

  end

end