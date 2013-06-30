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
        self.rest   = Nanosecond.duration self.from.to_time, to
      end

      def calculate_new(duration, to)
        from = to - duration

        self.amount = (to.year - from.year) / 1000
        new_from    = (from.to_datetime >> amount*12000).to_time
        self.rest   = Nanosecond.duration new_from, to
      end

    end

  end
end
