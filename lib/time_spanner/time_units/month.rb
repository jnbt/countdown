module TimeSpanner
  module TimeUnits

    class Month < TimeUnit

      def initialize
        super(5)
      end

      def calculate(from, to)
        self.amount = DurationHelper.months(from, to)
        self.rest   = DurationHelper.nanoseconds(from, to) - days_in_nanoseconds(from, to)
      end


      private

      def days_in_nanoseconds(from, to)
        DurationHelper.days(from, to) * 86400000000000
      end

    end

  end
end
