module TimeSpanner
  module TimeUnits

    class Day < CalendarUnit

      def initialize
        super 7
      end


      private

      def calculate_amount(from, to)
        (to.to_time - from.to_time).to_i / 86400
      end

      def from_at_amount
        (from.to_datetime + amount).to_time
      end

    end

  end
end
