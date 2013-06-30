require 'test_helper'

module TimeSpanner
  module TimeUnits

    class MillisecondTest < TestCase

      it 'initializes' do
        millisecond = Millisecond.new

        assert millisecond.kind_of?(TimeUnit)
        assert_equal 11, millisecond.position
        assert_equal :milliseconds, millisecond.plural_name
      end

      it 'calculates' do
        from        = Time.at Time.now.to_f
        to          = Time.at(from.to_f, 2000.0)
        millisecond = Millisecond.new

        nanoseconds = Nanosecond.duration from, to

        millisecond.calculate(nanoseconds)

        assert_equal 2, millisecond.amount
        assert_equal 0, millisecond.rest
      end

      it 'calculates with rest' do
        from          = Time.at Time.now.to_r
        target_millis = Time.at(from.to_r, 2000.0)
        to            = Time.at(target_millis.to_time.to_r, 0.999)
        millisecond   = Millisecond.new

        nanoseconds = Nanosecond.duration from, to
        millisecond.calculate(nanoseconds)

        assert_equal 2, millisecond.amount
        assert_equal 999, millisecond.rest
      end

    end
  end
end