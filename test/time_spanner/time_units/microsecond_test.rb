require 'test_helper'

module TimeSpanner
  module TimeUnits

    class MicrosecondTest < TestCase

      it 'initializes' do
        microsecond = Microsecond.new

        assert microsecond.kind_of?(TimeUnit)
        assert_equal 12, microsecond.position
        assert_equal :microseconds, microsecond.plural_name
      end

      it 'calculates' do
        from = Time.at Time.now.to_f
        to   = Time.at(from.to_f, 2.0)
        microsecond   = Microsecond.new

        nanoseconds = Nanosecond.duration from, to
        microsecond.calculate(nanoseconds)

        assert_equal 2, microsecond.amount
        assert_equal 0, microsecond.rest
      end

      it 'calculates with rest' do
        from = Time.at Time.now.to_r
        target_micros = Time.at(from.to_r, 2.0)
        to   = Time.at(target_micros.to_time.to_r, 0.999)
        microsecond   = Microsecond.new

        nanoseconds = Nanosecond.duration from, to
        microsecond.calculate(nanoseconds)

        assert_equal 2, microsecond.amount
        assert_equal 999, microsecond.rest
      end

    end
  end
end