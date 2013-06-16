module Countdown
  module ContentTags

    class ContentTag
      attr_reader :tag_type, :attributes

      def initialize(tag_type, attributes={})
        @tag_type   = tag_type
        @attributes = attributes
      end

      def to_s(&block)
        "<#{tag_type} #{html_attributes}>" + (block_given? ? yield : '') + "</#{tag_type}>"
      end

      def html_attributes
        attributes.map {|k, v| "#{k}=\"#{v}\"" }.join(' ')
      end

    end

  end
end