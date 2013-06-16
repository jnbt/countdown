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

      it 'creates html' do
        assert_equal '<span class="minutes-1">1</span>', @time_unit.to_html
      end
    end

  end
end