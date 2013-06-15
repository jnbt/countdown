require 'test_helper'
require 'date'

module Countdown
  module ContentTags
    class CountupTagTest < TestCase

      it 'should initialize' do
        assert CountupTag.new
      end

      it 'should render to string with block given' do
        string = 'test'
        tag = CountupTag.new.to_s { string }

        assert tag.is_a?(String)
        assert tag.include?(string)
      end

      it 'should render to string without block' do
        tag = CountupTag.new.to_s

        assert tag.is_a?(String)
      end

    end
  end
end