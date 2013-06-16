module Countdown
  module Counters

    class Counter
      include ::Countdown::ContentTags

      DEFAULT_DIRECTION = :down

      attr_reader :direction, :time

      def initialize(time, options)
        @direction = options.delete(:direction) || DEFAULT_DIRECTION
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