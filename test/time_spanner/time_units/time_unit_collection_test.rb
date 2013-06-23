require 'test_helper'
require 'date'

module TimeSpanner
  module TimeUnits
    include TimeHelpers

    class TimeUnitCollectionTest < TestCase

      it 'initializes' do
        collection = TimeUnitCollection.new(3453453)
        collection << Hour.new(:hour)

        assert_equal 1, collection.units.size
      end

      it 'calculates hours' do
        starting_time = DateTime.parse('2013-04-03 00:00:00')
        target_time   = DateTime.parse('2013-04-03 02:00:00')

        nanos      = TimeHelpers::TimeSpan.new(starting_time, target_time).total_nanos
        collection = TimeUnitCollection.new nanos
        collection << Hour.new(:hour)

        collection.calculate

        assert_equal 2, collection.units.first.amount
        assert_equal 0, collection.units.first.rest
      end

      it 'calculates hours and minutes' do
        starting_time = DateTime.parse('2013-04-03 00:00:00')
        target_time   = DateTime.parse('2013-04-03 02:45:00')

        nanos      = TimeHelpers::TimeSpan.new(starting_time, target_time).total_nanos
        collection = TimeUnitCollection.new nanos
        collection << Hour.new(:hour)
        collection << Minute.new(:minute)
        collection.sort!

        collection.calculate

        assert_equal 2, collection.units.first.amount
        assert_equal 45, collection.units.first.rest
        #assert_equal 45, collection.units.last.amount
        #assert_equal 0, collection.units.last.rest
      end

    end
  end
end