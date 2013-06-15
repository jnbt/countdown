module Countdown
  module ContentTags

    class CountupTag

      CSS_CLASS = 'countup'

      def to_s(&block)
        "<div class=\"#{CSS_CLASS}\">" + (block_given? ? yield : '') + '</div>'
      end

    end

  end
end