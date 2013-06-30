require 'test_helper'

module TimeSpanner

  class TimeUnitCollectorTest < TestCase

    before do
      @now = Time.now
    end

    it 'initializes' do
      collector = TimeUnitCollector.new [:hours]

      assert_equal [:hours], collector.unit_names
    end

    it 'validates time units' do
      assert_raises InvalidUnitError do
        TimeUnitCollector.new [:days, :something]
      end
    end

  end

end