module Countdown
  module Counters

    class UpCounter
      include ::Countdown::ContentTags

      attr_reader :time

      def initialize(time, options)
        @time = time
      end

      def to_html
        CountupTag.new.to_s do
          time.to_s
        end
      end

    end

  end
end