module TimeSpanner
  module TimeUnits

    class Day < TimeUnit

      attr_accessor :from

      def initialize
        super 7
      end

      def calculate(from, to)
        self.amount = (to.to_time - from.to_time).to_i / 86400
        self.from   = from.to_datetime + amount
        self.rest   = Nanosecond.duration self.from.to_time, to
      end

    end

  end
end
