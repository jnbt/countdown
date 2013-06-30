module TimeSpanner
  module TimeUnits

    class Century < TimeUnit

      attr_accessor :from

      def initialize
        super 2
      end

      def calculate(from, to)
        self.amount = (to.year - from.year) / 100
        self.from   = from.to_datetime >> amount*1200
        self.rest   = Nanosecond.duration self.from.to_time, to
      end

      def plural_name
        :centuries
      end

    end

  end
end
