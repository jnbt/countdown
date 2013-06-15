module Countdown
  module ContentTags

    class CountdownTag

      CSS_CLASS = 'countdown'

      def to_s(&block)
        "<div class=\"#{CSS_CLASS}\">" + (block_given? ? yield : '') + '</div>'
      end

    end

  end
end