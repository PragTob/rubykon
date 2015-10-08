require_relative 'spec_helper'
require 'stringio'

module Rubykon
  RSpec.describe CLI do
    subject {described_class.new}
    context 'stubbed out MCTS' do
      let(:fake_root) {double 'fake_root', best_move: [33, :black],
                                           children: children}
      let(:children) do
        (0..9).map {double 'child', move: [33, :black], win_percentage: 0.5}
      end

      before :each do
        allow_any_instance_of(MCTS::MCTS).to receive(:start).and_return(fake_root)
      end

      describe 'choosing a board' do

        # input has to go in before starting, otherwise we are stuck waiting
        it "displays a message prompting the user to choose a game type" do
          output = FakeIO.each_input ['exit'] do
            subject.start
          end

          expect(output).to match /board size/
          expect(output).to match /9.*13.*19/
        end

        it "waits for some input of a board size" do
          output = FakeIO.each_input %w(9 exit) do
            subject.start
          end
          expect(output).to match /starting.*9x9/
        end

        it "keeps prompting until a number was entered" do
          output = FakeIO.each_input %w(h9 19 exit) do
            subject.start
          end
          expect(output).to match /number.*try again/i
          expect(output).to match /starting/i
        end

        it "makes a whole test through all the things" do
          output = FakeIO.each_input %w(9 1-1 exit) do
            subject.start
          end

          expect(output).to match Board.new(9).to_s
          expect(output).to match /O......../
          expect(output).to match /starting/i
        end
      end
    end

    context 'real MCTS' do
      it "does not blow up (but we take a very small board" do
        output = FakeIO.each_input %w(2 2-1 exit) do
          subject.start
        end

        expect(output).to match /thinking/
        expect(output).to match /black/
        expect(output).to match /white/
      end
    end
  end
end