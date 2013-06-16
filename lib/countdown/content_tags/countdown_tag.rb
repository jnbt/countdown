module Countdown
  module ContentTags

    class CountdownTag < ContentTag

      def initialize(direction)
        super :div, class: "count#{direction}"
      end

    end

  end
end