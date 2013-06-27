module TimeSpanner
  module TimeUnits

    class Millennium < TimeUnit

      attr_accessor :from

      def initialize
        super 1
      end

      def calculate(from, to)
        self.amount = (to.year - from.year) / 1000
        self.from   = from.to_datetime >> amount*12000
        self.rest   = DurationHelper.nanoseconds self.from, to
      end

    end

  end
end
