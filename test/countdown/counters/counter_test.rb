require 'test_helper'
require 'date'

module Countdown
  module Counters
    class CounterTest < TestCase

      it 'should initialize' do
        time = DateTime.now+1
        counter = Counter.new(time, options={})

        assert_equal time, counter.time
      end

    end
  end
end