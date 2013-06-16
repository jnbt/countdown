require 'test_helper'

module Countdown
  module TagBuilders

    class UnitSeparatorBuilderTest < TestCase

      before do
        @separator = UnitSeparatorBuilder.new(:minutes, {value: 'm'})
      end

      it 'has value' do
        assert_equal 'm', @separator.value
      end

      it 'has unit' do
        assert_equal :minutes, @separator.unit
      end

      it 'has default alignment' do
        assert_equal UnitSeparatorBuilder::DEFAULT_ALIGN, @separator.align
        refute @separator.before?
        assert @separator.after?
      end

      it 'overwrites default alignment' do
        separator = UnitSeparatorBuilder.new(:minutes, {value: 'm', align: :before})

        assert_equal :before, separator.align
        assert separator.before?
        refute separator.after?
      end

      it 'creates html' do
        assert_equal '<span class="minutes-separator">m</span>', @separator.to_html
      end
    end
  end
end