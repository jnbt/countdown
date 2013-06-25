require 'test_helper'
require 'date'

module TimeSpanner
  module TimeUnits

    class TimeUnitCollectionTest < TestCase

      before do
        @now = DateTime.now
      end

      it 'initializes' do
        collection = TimeUnitCollection.new(@now, @now+1, [:hours])

        assert_equal 1, collection.units.size
      end

      it 'validates time units' do
        assert_raises InvalidUnitError do
          TimeUnitCollection.new(@now, @now, [:days, :something])
        end
      end

    end
  end
end