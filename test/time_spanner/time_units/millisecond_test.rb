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
        from        = Time.now
        to          = Time.at(from.to_r, 2000.0)
        duration    = to.to_r - from.to_r
        millisecond = Millisecond.new

        millisecond.calculate duration

        assert_equal 2, millisecond.amount
        assert_equal 0, millisecond.rest
      end

      it 'calculates with rest (999 nanoseconds in seconds)' do
        from          = Time.now
        target_millis = Time.at(from.to_r, 2000.0)
        to            = Time.at(target_millis.to_r, 0.999)
        duration      = to.to_r - from.to_r
        millisecond   = Millisecond.new

        millisecond.calculate duration

        assert_equal 2, millisecond.amount
        assert_equal Rational(8998192055486251, 9007199254740992000000), millisecond.rest
      end

    end
  end
end