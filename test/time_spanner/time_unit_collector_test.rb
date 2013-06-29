require 'test_helper'

module TimeSpanner

  class TimeUnitCollectorTest < TestCase

    before do
      @now = DateTime.now
    end

    it 'initializes' do
      collector = TimeUnitCollector.new(@now, @now+1, [:hours])

      assert collector.duration_chain.is_a?(DurationChain)
      assert_equal [:hours], collector.unit_names
    end

    it 'validates time units' do
      assert_raises InvalidUnitError do
        TimeUnitCollector.new(@now, @now, [:days, :something])
      end
    end

  end

end