require 'test_helper'
require 'date'

module Countdown
  module Counters
    class UpCounterTest < TestCase

      it 'should initialize' do
        time = DateTime.now+1
        counter = UpCounter.new(time, options={})

        assert_equal time, counter.time
      end

    end
  end
end