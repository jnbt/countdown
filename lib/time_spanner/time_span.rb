module TimeSpanner

  class TimeSpan < Hash
    include Errors

    attr_reader :unit_chain

    def initialize(from, to, unit_names=[])
      validate! from, to

      units       = TimeUnitCollector.new(unit_names).units
      @unit_chain = DurationChain.new(from, to, units)

      build!
    end


    private

    def build!
      unit_chain.each do |unit|
        self[unit.plural_name] = unit.amount
      end
    end

    def validate!(from, to)
      raise InvalidClassError, "Must convert to Time object!" unless [from, to].all?{ |obj| obj.respond_to?(:to_time) && obj.to_time.is_a?(Time)}
    end

  end

end