module TimeSpanner

  class DurationChain
    include Enumerable
    include TimeHelpers

    attr_accessor :units
    attr_reader   :duration

    def initialize(from, to, units)
      @duration = DurationHelper.nanoseconds(from, to)
      @units    = units

      sort!
      calculate!
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

    # Perform duration calculations for units in chain.
    def calculate!
      nanoseconds = duration

      each do |unit|
        unit.calculate(nanoseconds)
        nanoseconds = unit.rest
      end
    end

  end

end
