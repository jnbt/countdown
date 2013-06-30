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

    describe "collecting unit names" do

      it 'should use all units when if no units are given (no parameter given)' do
        collector = TimeUnitCollector.new

        assert_equal TimeUnitCollector::AVAILABLE_UNITS, collector.unit_names
      end

      it 'should use all units when if no units are given (nil given)' do
        collector = TimeUnitCollector.new nil

        assert_equal TimeUnitCollector::AVAILABLE_UNITS, collector.unit_names
      end

      it 'should use all units when if no units are given (empty Array given)' do
        collector = TimeUnitCollector.new []

        assert_equal TimeUnitCollector::AVAILABLE_UNITS, collector.unit_names
      end

    end

  end

end