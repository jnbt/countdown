require 'test_helper'

module TimeSpanner
  module TimeUnits

    class NanosecondTest < TestCase

      it 'initializes' do
        nanosecond = Nanosecond.new

        assert nanosecond.kind_of?(TimeUnit)
        assert_equal 13, nanosecond.position
        assert_equal :nanoseconds, nanosecond.plural_name
      end

      it 'calculates amount' do
        from       = Time.now
        to         = Time.at(from.to_r, 0.002)
        duration   = to.to_r - from.to_r
        nanosecond = Nanosecond.new

        nanosecond.calculate duration

        assert_equal 2, nanosecond.amount
      end

      it 'calculates amount on odd nanoseconds' do
        from       = Time.at(DateTime.parse('2013-07-28 00:00:01').to_time, 0.021)
        to         = Time.at(DateTime.parse('2013-07-28 00:00:01').to_time, 0.023)
        duration   = to.to_r - from.to_r
        nanosecond = Nanosecond.new

        nanosecond.calculate duration

        assert_equal 2, nanosecond.amount
      end

    end
  end
end