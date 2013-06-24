require 'test_helper'
require 'date'

module TimeSpanner
  module TimeUnits
    include TimeHelpers

    class TimeUnitCollectionTest < TestCase

      it 'initializes' do
        collection = TimeUnitCollection.new(3453453, [:hours])

        assert_equal 1, collection.units.size
      end

      it 'calculates 1 unit' do
        starting_time = DateTime.parse('2013-04-03 00:00:00')
        target_time   = DateTime.parse('2013-04-03 02:00:00')

        nanoseconds = TimeHelpers::TimeSpan.new(starting_time, target_time).total_nanoseconds
        collection  = TimeUnitCollection.new(nanoseconds, [:hours])

        assert_equal 2, collection.units.first.amount
      end

      it 'calculates 2 units in a row' do
        starting_time = DateTime.parse('2013-04-03 00:00:00')
        target_time   = DateTime.parse('2013-04-03 02:45:00')

        nanoseconds = TimeHelpers::TimeSpan.new(starting_time, target_time).total_nanoseconds
        collection  = TimeUnitCollection.new(nanoseconds, [:hours, :minutes])

        assert_equal 2, collection.units.first.amount
        assert_equal 45, collection.units.last.amount
      end

      it 'should sort' do
        collection  = TimeUnitCollection.new(345346435657567567, [:minutes, :hours])

        assert collection.units.first.is_a?(Hour)
        assert collection.units.last.is_a?(Minute)
      end

    end
  end
end