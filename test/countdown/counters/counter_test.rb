require 'test_helper'
require 'date'

module Countdown
  module Counters
    class CounterTest < TestCase

      before do
        time = DateTime.now+1
        @counter = Counter.new(time, options={})
      end

      it 'should initialize with default values' do
        assert @counter.timer.is_a?(CountdownTimer)
        assert_equal Counter::DEFAULT_DIRECTION, @counter.direction
        assert_equal Counter::DEFAULT_UNITS, @counter.units
        assert_equal Counter::DEFAULT_SEPARATORS, @counter.separators
      end

      it 'creates html' do
        assert @counter.to_html.is_a?(String)
      end

    end
  end
end