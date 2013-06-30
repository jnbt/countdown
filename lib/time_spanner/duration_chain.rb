module TimeSpanner

  class DurationChain
    include Enumerable
    include TimeUnits

    attr_accessor :current_time, :remaining, :units
    attr_reader   :from, :to

    def initialize(from, to, units)
      @current_time = from
      @to           = to
      @remaining    = Nanosecond.duration from, to
      @units        = units.map &:new

      calculate!
    end

    def each
      units.each do |unit|
        yield unit
      end
    end

    private

    # Perform duration calculations for units in chain.
    def calculate!
      sort!

      each do |unit|
        calculate_unit(unit)
      end
    end

    # Units must be sorted to perform a correct calculation chain.
    def sort!
      self.units = units.sort
    end

    def calculate_unit(unit)
      unit.calculate remaining, to
      self.remaining = unit.rest
    end

  end

end
