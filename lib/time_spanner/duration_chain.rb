module TimeSpanner

  class DurationChain
    include Enumerable
    include TimeHelpers
    include TimeUnits

    attr_accessor :remaining_time, :units

    def initialize(from, to)
      @remaining_time = DurationHelper.nanoseconds(from, to)
      @units          = []
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
      sort!

      each do |unit|
        calculate_unit(unit)
      end
    end

    private

    def calculate_unit(unit)
      if [Month, Day].include?(unit.class)
        unit.calculate(from, to)
      else
        unit.calculate(remaining_time)
      end

      self.remaining_time = unit.rest
    end

  end

end
