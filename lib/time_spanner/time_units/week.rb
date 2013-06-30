module TimeSpanner
  module TimeUnits

    class Week < CalendarUnit

      def initialize
        super 6
      end


      private

      def calculate_amount(from, to)
        ((to.to_datetime - from.to_datetime) / 7).to_i
      end

      def at_amount
        (from.to_datetime + amount * 7).to_time
      end

    end

  end
end
