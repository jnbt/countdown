module TimeSpanner
  module TimeUnits

    class Month < TimeUnit

      attr_reader :from, :to

      def initialize(from, to)
        super(5, 1)

        @from  = from
        @to    = to
      end

      def calculate(duration) # duration equals to - from!
        self.amount = DurationHelper.months(from, to)
        self.rest   = duration - days_in_nanoseconds
      end


      private

      def days_in_nanoseconds
        DurationHelper.days(from, to) * 86400000000000
      end

    end

  end
end
