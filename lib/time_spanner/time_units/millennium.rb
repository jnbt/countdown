module TimeSpanner
  module TimeUnits

    class Millennium < CalendarUnit

      def initialize
        super 1
      end


      private

      def calculate_amount(from, to)
        (to.year - from.year) / 1000
      end

      def at_amount
        (from.to_datetime >> amount*12000).to_time
      end

    end

  end
end
