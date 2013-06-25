module TimeSpanner
  module TimeUnits

    class Day < TimeUnit

      attr_reader :from, :to, :leaps

      def initialize(from, to)
        super(7, 86400000000000)

        @from  = from
        @to    = to
        @leaps = DateHelper.leap_count from, to
      end

      def calculate(duration) # duration equals to - from!
        self.amount = DurationHelper.days(from, to) - leaps

        calculate_rest(duration - leaps * nano_multiplier)
      end

    end

  end
end
