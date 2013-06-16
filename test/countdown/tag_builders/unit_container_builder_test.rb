require 'test_helper'

module Countdown
  module TagBuilders

    class UnitContainerBuilderTest < TestCase

      before do
        @unit_tag_builder = UnitContainerBuilder.new(:minutes, 1, {value: 'm'})
      end

      it 'has unit' do
        assert_equal :minutes, @unit_tag_builder.unit
      end

      it 'has time_unit' do
        assert @unit_tag_builder.time_unit.is_a?(TimeUnitBuilder)
      end

      it 'has unit_separator' do
        assert @unit_tag_builder.unit_separator.is_a?(UnitSeparatorBuilder)
      end

      it 'singularizes' do
        assert @unit_tag_builder.singularize?
      end

      it 'does not singularize' do
        unit_tag_builder = UnitContainerBuilder.new(:minutes, 0, {value: 'm'})

        refute unit_tag_builder.singularize?
      end

      it 'creates html' do
        expected = '<span class="minutes"><span class="minutes-1">1</span><span class="separator minutes" data-singular="m" data-plural="m">m</span></span>'

        assert_equal expected, @unit_tag_builder.to_html
      end

      it 'creates html with separator aligned before' do
        expected = '<span class="minutes"><span class="separator minutes" data-singular="m" data-plural="m">m</span><span class="minutes-1">1</span></span>'
        unit_tag_builder = UnitContainerBuilder.new(:minutes, 1, {value: 'm', align: :before})

        assert_equal expected, unit_tag_builder.to_html
      end
    end

  end
end