module Countdown
  module ContentTags

    class CountdownTag

      attr_reader :css_class

      def initialize(direction=:down)
        @css_class = "count#{direction}"
      end

      def to_s(&block)
        "<div class=\"#{css_class}\">" + (block_given? ? yield : '') + '</div>'
      end

    end

  end
end