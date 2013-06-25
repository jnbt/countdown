require 'test_helper'
require 'date'

module TimeSpanner
  module TimeUnits
    include TimeHelpers

    class TimeUnitCollectionTest < TestCase

      before do
        @now = DateTime.now
      end

      it 'initializes' do
        collection = TimeUnitCollection.new(@now, @now+1, [:hours])

        assert_equal 1, collection.units.size
      end

      it 'sorts itself' do
        collection  = TimeUnitCollection.new(@now, @now+1, [:minutes, :hours])

        assert collection.units.first.is_a?(Hour)
        assert collection.units.last.is_a?(Minute)
      end

      describe 'calculation by given units' do

        it 'calculates 1 unit' do
          starting_time = DateTime.parse('2013-04-03 00:00:00')
          target_time   = DateTime.parse('2013-04-03 02:00:00')
          collection = TimeUnitCollection.new(starting_time, target_time, [:hours])

          assert_equal 2, collection.units.first.amount
        end

        it 'calculates 2 units in a row' do
          starting_time = DateTime.parse('2013-04-03 00:00:00')
          target_time   = DateTime.parse('2013-04-03 02:45:00')

          collection = TimeUnitCollection.new(starting_time, target_time, [:hours, :minutes])

          assert_equal 2, collection.units.first.amount
          assert_equal 45, collection.units.last.amount
        end

      end

    end
  end
end