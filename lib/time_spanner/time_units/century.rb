module TimeSpanner
  module TimeUnits

    class Century < TimeUnit

      attr_accessor :from

      def initialize
        super 2
      end

      def calculate(from, to)
        centuries, rest = DurationHelper.centuries_with_rest(from, to)

        self.amount = centuries
        self.rest   = rest
        self.from   = from.to_datetime >> amount*1200
      end

    end

  end
end
