module TimeSpanner
  module TimeUnits

    class Month < CalendarUnit

      def initialize
        super 5
      end


      private

      def calculate_amount(from, to)
        (to.year*12 + to.month) - (from.year*12 + from.month) - (to.day < from.day ? 1 : 0)
      end

      def from_at_amount
        (from.to_datetime >> amount).to_time
      end

    end

  end
end
