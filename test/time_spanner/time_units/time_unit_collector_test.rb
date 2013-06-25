require 'test_helper'
require 'date'

module TimeSpanner
  module TimeUnits

    class TimeUnitCollectorTest < TestCase

      before do
        @now = DateTime.now
      end

      it 'initializes' do
        collector = TimeUnitCollector.new(@now, @now+1, [:hours])

        assert_equal 1, collector.units.size
      end

      it 'validates time units' do
        assert_raises InvalidUnitError do
          TimeUnitCollector.new(@now, @now, [:days, :something])
        end
      end

    end
  end
end