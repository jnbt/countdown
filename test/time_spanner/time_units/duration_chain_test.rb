require 'test_helper'
require 'date'

module TimeSpanner
  module TimeUnits

    class DurationChainTest < TestCase

      describe 'calculation by given units' do

        before do
          @from = DateTime.parse('2013-04-03 00:00:00')
          @to   = DateTime.parse('2013-04-03 02:12:37')

          @hour   = Hour.new
          @minute = Minute.new
          @second = Second.new
        end

        it 'sorts' do
          chain  = DurationChain.new(@from, @to, [@second, @hour, @minute])

          assert chain.units.first.is_a?(Hour)
          assert chain.units[1].is_a?(Minute)
          assert chain.units.last.is_a?(Second)
        end

        describe 'one unit given' do

          it 'calculates hours' do
            chain = DurationChain.new(@from, @to, [@hour])

            assert_equal 2, chain.units.first.amount
          end

          it 'calculates minutes' do
            chain = DurationChain.new(@from, @to, [@minute])

            assert_equal 132, chain.units.first.amount
          end

          it 'calculates seconds' do
            chain = DurationChain.new(@from, @to, [@second])

            assert_equal 7957, chain.units.first.amount
          end

        end

        describe 'two units given' do

          it 'calculates hours and minutes' do
            chain = DurationChain.new(@from, @to, [@hour, @minute])

            assert_equal 2, chain.units.first.amount
            assert_equal 12, chain.units.last.amount
          end

          it 'calculates minutes and seconds' do
            chain = DurationChain.new(@from, @to, [@minute, @second])

            assert_equal 132, chain.units.first.amount
            assert_equal 37, chain.units.last.amount
          end

          it 'calculates hours and seconds' do
            chain = DurationChain.new(@from, @to, [@hour, @second])

            assert_equal 2, chain.units.first.amount
            assert_equal 757, chain.units.last.amount
          end

        end

        describe 'three units given' do

          it 'calculates hours, minutes and seconds' do
            chain = DurationChain.new(@from, @to, [@hour, @minute, @second])

            assert_equal 2, chain.units.first.amount
            assert_equal 12, chain.units[1].amount
            assert_equal 37, chain.units.last.amount
          end

        end

      end

    end
  end
end
