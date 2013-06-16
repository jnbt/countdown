module Countdown
  module Counters

    class CountdownTimer
      attr_reader :time, :years, :months, :weeks, :days, :hours, :minutes, :seconds, :millis

      def initialize(time)
        @time    = time
        @years   = calculate_years
        @months  = calculate_months
        @weeks   = calculate_weeks
        @days    = calculate_days
        @hours   = calculate_hours
        @minutes = calculate_minutes
        @seconds = calculate_seconds
        @millis  = calculate_millis
      end

      def [](unit)
        send unit
      end

      private

      def calculate_years
        1
      end

      def calculate_months
        1
      end

      def calculate_weeks
        1
      end

      def calculate_days
        1
      end

      def calculate_hours
        1
      end

      def calculate_minutes
        1
      end

      def calculate_seconds
        1
      end

      def calculate_millis
        1
      end

    end

  end
end