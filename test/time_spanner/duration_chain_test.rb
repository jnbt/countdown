require 'test_helper'
require 'date'

module TimeSpanner

  class DurationChainTest < TestCase
    include TimeUnits

    describe 'calculation by given units' do

      before do
        @from = DateTime.parse('2013-04-03 00:00:00')
        @to   = DateTime.parse('2013-04-03 02:12:37')

        @hour   = Hour.new
        @minute = Minute.new
        @second = Second.new
      end

      it 'initializes' do
        chain  = DurationChain.new(@from, @to)

        assert_equal @from, chain.from
        assert_equal @to, chain.to
        assert_equal 7957000000000, chain.remaining_time
        assert_equal [], chain.units
      end

      it 'sorts' do
        chain  = DurationChain.new(@from, @to)
        [@second, @hour, @minute].each { |unit| chain << unit }
        chain.sort!

        assert chain.units.first.is_a?(Hour)
        assert chain.units[1].is_a?(Minute)
        assert chain.units.last.is_a?(Second)
      end

      describe 'one unit given' do

        it 'calculates hours' do
          chain = DurationChain.new(@from, @to)
          chain << @hour
          chain.calculate!

          assert_equal 2, chain.units.first.amount
        end

        it 'calculates minutes' do
          chain = DurationChain.new(@from, @to)
          chain << @minute
          chain.calculate!

          assert_equal 132, chain.units.first.amount
        end

        it 'calculates seconds' do
          chain = DurationChain.new(@from, @to)
          chain << @second
          chain.calculate!

          assert_equal 7957, chain.units.first.amount
        end

      end

      describe 'two units given' do

        it 'calculates hours and minutes' do
          chain = DurationChain.new(@from, @to)
          [@hour, @minute].each { |unit| chain << unit }
          chain.calculate!

          assert_equal 2, chain.units.first.amount
          assert_equal 12, chain.units.last.amount
        end

        it 'calculates minutes and seconds' do
          chain = DurationChain.new(@from, @to)
          [@minute, @second].each { |unit| chain << unit }
          chain.calculate!

          assert_equal 132, chain.units.first.amount
          assert_equal 37, chain.units.last.amount
        end

        it 'calculates hours and seconds' do
          chain = DurationChain.new(@from, @to)
          [@second, @hour].each { |unit| chain << unit }
          chain.calculate!

          assert_equal 2, chain.units.first.amount
          assert_equal 757, chain.units.last.amount
        end

        it 'calculates months and days' do
          from   = DateTime.parse('2013-04-01 00:00:00')
          to     = DateTime.parse('2013-07-19 00:00:00')
          month  = Month.new
          day    = Day.new
          chain  = DurationChain.new(from, to)

          [month, day].each { |unit| chain << unit }
          chain.calculate!

          assert_equal 3, chain.units.first.amount
          assert_equal 18, chain.units.last.amount
        end

        it 'calculates months with microseconds' do
          from             = DateTime.parse('2013-04-01 00:00:00')
          from_with_months = DateTime.parse('2013-08-01 00:00:00')
          to               = Time.at(from_with_months.to_time.to_f, 2.0)
          month            = Month.new
          microsecond      = Microsecond.new
          chain            = DurationChain.new(from, to)

          [month, microsecond].each { |unit| chain << unit }
          chain.calculate!

          assert_equal 4, chain.units.first.amount
          assert_equal 2, chain.units.last.amount
        end

        it 'calculates years and months' do
          from   = DateTime.parse('2013-04-01 00:00:00')
          to     = DateTime.parse('2016-08-01 00:00:00')
          year   = Year.new
          month  = Month.new
          chain  = DurationChain.new(from, to)

          [year, month].each { |unit| chain << unit }
          chain.calculate!

          assert_equal 3, chain.units.first.amount
          assert_equal 4, chain.units.last.amount
        end

        it 'calculates decades and years' do
          from   = DateTime.parse('2013-04-01 00:00:00')
          to     = DateTime.parse('2036-04-01 00:00:00')
          decade = Decade.new
          year   = Year.new
          chain  = DurationChain.new(from, to)

          [decade, year].each { |unit| chain << unit }
          chain.calculate!

          assert_equal 2, chain.units.first.amount
          assert_equal 3, chain.units.last.amount
        end

        it 'calculates centuries and years' do
          from    = DateTime.parse('2013-04-01 00:00:00')
          to      = DateTime.parse('2216-04-01 00:00:00')
          century = Century.new
          year    = Year.new
          chain   = DurationChain.new(from, to)

          [century, year].each { |unit| chain << unit }
          chain.calculate!

          assert_equal 2, chain.units.first.amount
          assert_equal 3, chain.units.last.amount
        end

        it 'calculates milleniums and seconds' do
          from       = DateTime.parse('2013-04-01 00:00:00')
          to         = DateTime.parse('4013-04-01 00:02:24')
          millennium = Millennium.new
          second     = Second.new
          chain      = DurationChain.new(from, to)

          [millennium, second].each { |unit| chain << unit }
          chain.calculate!

          assert_equal 2, chain.units.first.amount
          assert_equal 144, chain.units.last.amount
        end

      end

      describe 'three units given' do

        it 'calculates hours, minutes and seconds' do
          chain = DurationChain.new(@from, @to)
          [@hour, @minute, @second].each { |unit| chain << unit }
          chain.calculate!

          assert_equal 2, chain.units.first.amount
          assert_equal 12, chain.units[1].amount
          assert_equal 37, chain.units.last.amount
        end

        it 'calculates months and days and hours' do
          from   = DateTime.parse('2013-04-01 00:00:00')
          to     = DateTime.parse('2013-07-19 02:00:00')
          month  = Month.new
          day    = Day.new
          hour   = Hour.new
          chain  = DurationChain.new(from, to)

          [month, day, hour].each { |unit| chain << unit }
          chain.calculate!

          assert_equal 3, chain.units.first.amount
          assert_equal 18, chain.units[1].amount
          assert_equal 2, chain.units.last.amount
        end

      end

    end

  end

end
