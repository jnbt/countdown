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
        from        = Time.now
        to          = Time.at(from.to_r, 2.0)
        duration    = to.to_r - from.to_r
        microsecond = Microsecond.new

        microsecond.calculate duration

        assert_equal 2, microsecond.amount
        assert_equal 0, microsecond.rest
      end

      it 'calculates with rest (999 nanoseconds in seconds)' do
        from          = Time.now
        target_micros = Time.at(from.to_r, 2.0)
        to            = Time.at(target_micros.to_r, 0.999)
        duration      = to.to_r - from.to_r
        microsecond   = Microsecond.new

        microsecond.calculate duration

        assert_equal 2, microsecond.amount
        assert_equal Rational(8998192055486251, 9007199254740992000000), microsecond.rest
      end

    end
  end
end