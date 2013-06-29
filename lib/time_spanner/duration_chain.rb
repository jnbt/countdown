module TimeSpanner

  class DurationChain
    include Enumerable
    include TimeUnits

    attr_accessor :from, :remaining_time, :spanned_units
    attr_reader   :to

    def initialize(from, to, units)
      @from           = from
      @to             = to
      @remaining_time = Nanosecond.duration from, to
      @spanned_units  = units.map(&:new)

      calculate!
    end

    private

    def each
      spanned_units.each do |unit|
        yield unit
      end
    end

    # Perform duration calculations for units in chain.
    def calculate!
      sort!

      each do |unit|
        calculate_unit(unit)
      end
    end

    # Units must be sorted to perform a correct calculation chain.
    def sort!
      self.spanned_units = spanned_units.sort
    end

    def calculate_unit(unit)
      if [Millennium, Century, Decade, Year, Month, Week, Day].include?(unit.class)
        unit.calculate(from, to)
        self.from = unit.from
      else
        unit.calculate(remaining_time)
      end

      self.remaining_time = unit.rest
    end

  end

end
