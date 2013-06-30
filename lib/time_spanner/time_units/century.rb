module TimeSpanner
  module TimeUnits

    class Century < CalendarUnit

      def initialize
        super 2
      end

      # Overwrite!
      def plural_name
        :centuries
      end


      private

      def calculate_amount(from, to)
        (to.year - from.year) / 100
      end

      def from_at_amount
        (from.to_datetime >> amount*1200).to_time
      end

    end

  end
end
