require 'test_helper'
require 'date'

module Countdown
  module ContentTags
    class CountdownTagTest < TestCase

      before do
        @tag = CountdownTag.new(:down)
      end

      it 'should be a div' do
        assert_equal :div, @tag.tag_type
      end

      it 'has certain class by direction :down' do
        assert_equal "countdown", @tag.attributes[:class]
      end

      it 'has certain class by direction :up' do
        tag = CountdownTag.new(:up)

        assert_equal "countup", tag.attributes[:class]
      end

    end
  end
end