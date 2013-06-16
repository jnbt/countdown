require 'test_helper'

module Countdown
  module TagBuilders

    class TimeUnitBuilderTest < TestCase

      before do
        @time_unit = TimeUnitBuilder.new(:minutes, 1)
      end

      it 'has value' do
        assert_equal 1, @time_unit.value
      end

      it 'has unit' do
        assert_equal :minutes, @time_unit.unit
      end

      it 'has a 1 value' do
        [-1, 1].each do |n|
          time_unit = TimeUnitBuilder.new(:minutes, n)

          assert time_unit.one?
        end
      end

      it 'has no 1 value' do
        [-2, 0, 2].each do |n|
          time_unit = TimeUnitBuilder.new(:minutes, n)

          refute time_unit.one?
        end
      end

      it 'creates html' do
        assert_equal '<span class="minutes-1">1</span>', @time_unit.to_html
      end
    end

  end
end