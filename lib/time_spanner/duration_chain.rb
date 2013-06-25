module TimeSpanner

  class DurationChain
    include Enumerable
    include TimeHelpers
    include TimeUnits

    attr_accessor :units
    attr_reader   :duration

    def initialize(from, to)
      @duration = DurationHelper.nanoseconds(from, to)
      @units    = []
    end

    def each
      units.each do |unit|
        yield unit
      end
    end

    def <<(unit)
      units << unit
    end

    # Units must be sorted to be able to perform a calculation chain.
    def sort!
      self.units = units.sort
    end

    # Perform duration calculations for units in chain.
    def calculate!
      nanoseconds = duration
      sort!
      each do |unit|
        [Month, Day].include?(unit.class) ? unit.calculate(from, to): unit.calculate(nanoseconds)
        nanoseconds = unit.rest
      end
    end

  end

end
