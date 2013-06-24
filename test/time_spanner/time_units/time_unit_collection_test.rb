require 'test_helper'
require 'date'

module TimeSpanner
  module TimeUnits
    include TimeHelpers

    class TimeUnitCollectionTest < TestCase

      it 'initializes' do
        collection = TimeUnitCollection.new(3453453, [:hours])
        p collection.units

        assert_equal 1, collection.units.size
      end

      it 'calculates 1 unit' do
        starting_time = DateTime.parse('2013-04-03 00:00:00')
        target_time   = DateTime.parse('2013-04-03 02:00:00')

        nanos      = TimeHelpers::TimeSpan.new(starting_time, target_time).total_nanos
        collection = TimeUnitCollection.new(nanos, [:hours])

        collection.calculate

        assert_equal 2, collection.units.first.amount
      end

      it 'calculates 2 units in a row' do
        starting_time = DateTime.parse('2013-04-03 00:00:00')
        target_time   = DateTime.parse('2013-04-03 02:45:00')

        nanos      = TimeHelpers::TimeSpan.new(starting_time, target_time).total_nanos
        collection = TimeUnitCollection.new(nanos, [:hours, :minutes])

        collection.sort!
        collection.calculate

        assert_equal 2, collection.units.first.amount
        assert_equal 45, collection.units.last.amount
      end

    end
  end
end