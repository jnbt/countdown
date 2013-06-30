module TimeSpanner
  module TimeUnits

    class Week < TimeUnit

      attr_accessor :from

      def initialize
        super 6
      end

      def calculate(from, to)
        self.amount = ((to.to_datetime - from.to_datetime) / 7).to_i
        self.from   = from.to_datetime + amount * 7
        self.rest   = Nanosecond.duration self.from.to_time, to
      end

    end

  end
end
