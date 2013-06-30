module TimeSpanner
  module TimeUnits

    class Decade < CalendarUnit

      def initialize
        super 3
      end


      private

      def calculate_amount(from, to)
        (to.year - from.year) / 10
      end

      def from_at_amount
        (from.to_datetime >> amount*120).to_time
      end

    end

  end
end
