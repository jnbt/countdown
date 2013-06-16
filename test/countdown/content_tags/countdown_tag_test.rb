require 'test_helper'
require 'date'

module Countdown
  module ContentTags
    class CountdownTagTest < TestCase

      before do
        @tag = CountdownTag.new(:down)
      end

      it 'should render to string with block given' do
        string = 'test'
        tag = @tag.to_s { string }

        assert tag.is_a?(String)
        assert tag.include?(string)
      end

      it 'should render to string without block' do
        tag = @tag.to_s

        assert tag.is_a?(String)
      end

    end
  end
end