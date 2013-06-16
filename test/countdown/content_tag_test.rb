require 'test_helper'

module Countdown
  module ContentTags
    class ContentTagTest < TestCase

      before do
        @tag = ContentTag.new(:div)
      end

      it 'should convert tag to string with block given' do
        string = 'test'
        tag = @tag.to_s { string }

        assert tag.is_a?(String)
        assert tag.include?('<div')
        assert tag.include?('</div>')
        assert tag.include?(string)
      end

      it 'should convert tag to string without block' do
        tag = @tag.to_s

        assert tag.is_a?(String)
        assert tag.include?('<div')
        assert tag.include?('</div>')
      end

      it 'converts attributes to html attributes' do
        tag = ContentTag.new(:div, {:class => 'some-class', :'data-test' => '5'})

        assert_equal 'class="some-class" data-test="5"', tag.html_attributes
      end

    end
  end
end