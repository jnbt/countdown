module TimeSpanner
  module TimeUnits

    class Month < TimeUnit

      def initialize
        super 5
      end

      def calculate(from, to)
        self.amount = months(from, to)
        self.rest   = total_nanoseconds(from, to) - days_in_nanoseconds(from, to)
      end


      private

      def months(from, to)
        DurationHelper.months(from, to)
      end

      def days_in_nanoseconds(from, to)
        DurationHelper.days(from, to) * Day::MULTIPLIER
      end

    end

  end
end
