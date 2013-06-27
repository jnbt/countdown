module TimeSpanner

  class DurationChain
    include Enumerable
    include TimeHelpers
    include TimeUnits

    attr_accessor :from, :remaining_time, :units
    attr_reader   :to

    def initialize(from, to)
      @from           = from
      @to             = to
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

    # TODO: if unit.is_a?(CalendarUnit)
    def calculate_unit(unit)
      if [Year, Month, Day].include?(unit.class)
        unit.calculate(from, to)
        self.from = unit.from
      else
        unit.calculate(remaining_time)
      end

      self.remaining_time = unit.rest
    end

  end

end
