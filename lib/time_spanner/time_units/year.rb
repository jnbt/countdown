module TimeSpanner
  module TimeUnits

    class Year < CalendarUnit

      def initialize
        super 4
      end


      private

      def calculate_amount(from, to)
        to.year - from.year
      end

      def at_amount
        (from.to_datetime >> amount*12).to_time
      end

    end

  end
end
