require 'test_helper'

module TimeSpanner

  class DurationChainTest < TestCase
    include TimeUnits

    describe 'calculation by given units' do

      before do
        @from = DateTime.parse('2013-04-03 00:00:00')
        @to   = DateTime.parse('2013-04-03 02:12:37')
      end

      it 'initializes' do
        chain  = DurationChain.new(@from, @to, [])

        assert_equal @from, chain.current_time
        assert_equal @to, chain.to
        assert_equal 7957000000000, chain.remaining
        assert_equal [], chain.units
      end

      it 'sorts' do
        chain  = DurationChain.new(@from, @to, [Second, Hour, Minute])

        assert chain.units.first.is_a?(Hour)
        assert chain.units[1].is_a?(Minute)
        assert chain.units.last.is_a?(Second)
      end

      it 'calculates decades and succeeding units (ensures leap years are correctly calculated)' do
        from = DateTime.parse('2013-01-01 00:00:00')
        to   = DateTime.parse('2023-01-01 00:00:00')

        chain = DurationChain.new(from, to, [Decade, Year, Month, Week, Day, Hour, Minute, Second, Millisecond, Microsecond, Nanosecond])

        assert_equal 1, chain.units[0].amount
        assert_equal 0, chain.units[1].amount
        assert_equal 0, chain.units[2].amount
        assert_equal 0, chain.units[3].amount
        assert_equal 0, chain.units[4].amount
        assert_equal 0, chain.units[5].amount
        assert_equal 0, chain.units[6].amount
        assert_equal 0, chain.units[7].amount
        assert_equal 0, chain.units[8].amount
        assert_equal 0, chain.units[9].amount
        assert_equal 0, chain.units[10].amount
      end

      describe 'one unit given' do

        it 'calculates hours' do
          chain = DurationChain.new(@from, @to, [Hour])

          assert_equal 2, chain.units.first.amount
        end

        it 'calculates minutes' do
          chain = DurationChain.new(@from, @to, [Minute])

          assert_equal 132, chain.units.first.amount
        end

        it 'calculates seconds' do
          chain = DurationChain.new(@from, @to, [Second])

          assert_equal 7957, chain.units.first.amount
        end

      end

      describe 'two units given' do

        it 'calculates hours and minutes' do
          chain = DurationChain.new(@from, @to, [Hour, Minute])

          assert_equal 2, chain.units.first.amount
          assert_equal 12, chain.units.last.amount
        end

        it 'calculates minutes and seconds' do
          chain = DurationChain.new(@from, @to, [Minute, Second])

          assert_equal 132, chain.units.first.amount
          assert_equal 37, chain.units.last.amount
        end

        it 'calculates hours and seconds' do
          chain = DurationChain.new(@from, @to, [Second, Hour])

          assert_equal 2, chain.units.first.amount
          assert_equal 757, chain.units.last.amount
        end

        it 'calculates months and days' do
          from   = DateTime.parse('2013-04-01 00:00:00')
          to     = DateTime.parse('2013-07-19 00:00:00')
          chain  = DurationChain.new(from, to, [Month, Day])

          assert_equal 3, chain.units.first.amount
          assert_equal 18, chain.units.last.amount
        end

        it 'calculates months with microseconds' do
          from             = DateTime.parse('2013-04-01 00:00:00')
          from_with_months = DateTime.parse('2013-08-01 00:00:00')
          to               = Time.at(from_with_months.to_time.to_f, 2.0)
          chain            = DurationChain.new(from, to, [Month, Microsecond])

          assert_equal 4, chain.units.first.amount
          assert_equal 2, chain.units.last.amount
        end

        it 'calculates years and months' do
          from   = DateTime.parse('2013-04-01 00:00:00')
          to     = DateTime.parse('2016-08-01 00:00:00')
          chain  = DurationChain.new(from, to, [Year, Month])

          assert_equal 3, chain.units.first.amount
          assert_equal 4, chain.units.last.amount
        end

        it 'calculates decades and years' do
          from   = DateTime.parse('2013-04-01 00:00:00')
          to     = DateTime.parse('2036-04-01 00:00:00')
          chain  = DurationChain.new(from, to, [Decade, Year])

          assert_equal 2, chain.units.first.amount
          assert_equal 3, chain.units.last.amount
        end

        it 'calculates centuries and years' do
          from    = DateTime.parse('2013-04-01 00:00:00')
          to      = DateTime.parse('2216-04-01 00:00:00')
          chain   = DurationChain.new(from, to, [Century, Year])

          assert_equal 2, chain.units.first.amount
          assert_equal 3, chain.units.last.amount
        end

        it 'calculates milleniums and nanoseconds' do
          from               = DateTime.parse('2013-04-01 00:00:00')
          target_millenniums = DateTime.parse('4013-04-01 00:00:00')
          to                 = Time.at(target_millenniums.to_time.to_r, 0.001)
          chain              = DurationChain.new(from, to, [Millennium, Nanosecond])

          assert_equal 2, chain.units.first.amount
          assert_equal 1, chain.units.last.amount
        end

        it 'calculates weeks and days' do
          from  = DateTime.parse('2013-04-01 00:00:00')
          to    = DateTime.parse('2013-04-26 00:00:00')
          chain = DurationChain.new(from, to, [Week, Day])

          assert_equal 3, chain.units.first.amount
          assert_equal 4, chain.units.last.amount
        end

      end

      describe 'three units given' do

        it 'calculates hours, minutes and seconds' do
          chain = DurationChain.new(@from, @to, [Hour, Minute, Second])

          assert_equal 2, chain.units.first.amount
          assert_equal 12, chain.units[1].amount
          assert_equal 37, chain.units.last.amount
        end

        it 'calculates months, days and hours' do
          from  = DateTime.parse('2013-04-01 00:00:00')
          to    = DateTime.parse('2013-07-19 02:00:00')
          chain = DurationChain.new(from, to, [Month, Day, Hour])

          assert_equal 3, chain.units.first.amount
          assert_equal 18, chain.units[1].amount
          assert_equal 2, chain.units.last.amount
        end

        it 'calculates months, weeks and days' do
          from   = DateTime.parse('2013-04-01 00:00:00')
          to     = DateTime.parse('2013-07-19 02:00:00')
          chain  = DurationChain.new(from, to, [Month, Week, Day])

          assert_equal 3, chain.units.first.amount
          assert_equal 2, chain.units[1].amount
          assert_equal 4, chain.units.last.amount
        end

      end

      describe 'all units given' do

        it 'calculates everything' do
          from  = Time.at(DateTime.parse('2013-06-17 12:34:56').to_time, 2216234.383)
          to    = Time.at(DateTime.parse('5447-12-12 23:11:12').to_time, 3153476.737)
          chain = DurationChain.new(from, to, [Millennium, Century, Decade, Year, Month, Week, Day, Hour, Minute, Second, Millisecond, Microsecond, Nanosecond])

          assert_equal 3,   chain.units[0].amount
          assert_equal 4,   chain.units[1].amount
          assert_equal 3,   chain.units[2].amount
          assert_equal 4,   chain.units[3].amount
          assert_equal 5,   chain.units[4].amount
          assert_equal 3,   chain.units[5].amount
          assert_equal 4,   chain.units[6].amount
          assert_equal 10,  chain.units[7].amount
          assert_equal 36,  chain.units[8].amount
          assert_equal 16,  chain.units[9].amount
          assert_equal 937, chain.units[10].amount
          assert_equal 242, chain.units[11].amount
          assert_equal 354, chain.units[12].amount
        end

        it 'calculates only some of them' do
          from  = Time.at(DateTime.parse('2013-07-28 00:00:01').to_time, 0.021)
          to    = Time.at(DateTime.parse('2014-08-01 00:00:59').to_time, 0.023)
          chain = DurationChain.new(from, to, [Millennium, Century, Decade, Year, Month, Week, Day, Hour, Minute, Second, Millisecond, Microsecond, Nanosecond])

          assert_equal 0,  chain.units[0].amount
          assert_equal 0,  chain.units[1].amount
          assert_equal 0,  chain.units[2].amount
          assert_equal 1,  chain.units[3].amount
          assert_equal 0,  chain.units[4].amount
          assert_equal 0,  chain.units[5].amount
          assert_equal 4,  chain.units[6].amount
          assert_equal 0,  chain.units[7].amount
          assert_equal 0,  chain.units[8].amount
          assert_equal 58, chain.units[9].amount
          assert_equal 0,  chain.units[10].amount
          assert_equal 0,  chain.units[11].amount
          assert_equal 2,  chain.units[12].amount
        end

        it 'calculates nothing' do
          from  = Time.at(DateTime.parse('2013-07-28 00:00:01').to_time, 0.021)
          to    = Time.at(DateTime.parse('2013-07-28 00:00:01').to_time, 0.021)
          chain = DurationChain.new(from, to, [Millennium, Century, Decade, Year, Month, Week, Day, Hour, Minute, Second, Millisecond, Microsecond, Nanosecond])

          assert_equal 0, chain.units[0].amount
          assert_equal 0, chain.units[1].amount
          assert_equal 0, chain.units[2].amount
          assert_equal 0, chain.units[3].amount
          assert_equal 0, chain.units[4].amount
          assert_equal 0, chain.units[5].amount
          assert_equal 0, chain.units[6].amount
          assert_equal 0, chain.units[7].amount
          assert_equal 0, chain.units[8].amount
          assert_equal 0, chain.units[9].amount
          assert_equal 0, chain.units[10].amount
          assert_equal 0, chain.units[11].amount
          assert_equal 0, chain.units[12].amount
        end

      end

    end

  end

end
