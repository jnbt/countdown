require 'test_helper'
require 'date'

module Countdown
  class SeparatorTest < TestCase

    before do
      @separator = Separator.new(value: 'm')
    end

    it 'has value' do
      assert_equal 'm', @separator.value
    end

    it 'has default alignment' do
      assert_equal Separator::DEFAULT_ALIGN, @separator.align
      refute @separator.before?
      assert @separator.after?
    end

    it 'overwrites default alignment' do
      separator = Separator.new(value: 'm', align: :before)

      assert_equal :before, separator.align
      assert separator.before?
      refute separator.after?
    end

  end
end