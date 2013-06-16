module Countdown
  module Counters

    class Counter
      include ::Countdown::ContentTags

      DEFAULT_DIRECTION = :down
      DEFAULT_UNITS     = [:days, :hours, :minutes, :seconds]

      attr_reader :direction, :units, :time

      def initialize(time, options)
        @direction = options.delete(:direction) || DEFAULT_DIRECTION
        @units     = options.delete(:units) || DEFAULT_UNITS
        @time      = time
      end

      def to_html
        CountdownTag.new(direction).to_s do
          time.to_s
        end
      end

    end

  end
end