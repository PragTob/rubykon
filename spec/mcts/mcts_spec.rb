require_relative 'spec_helper'

module MCTS
  RSpec.describe MCTS do
    subject {MCTS.new }
    let(:double_step) {Examples::DoubleStep.new}

    it "returns the best move (2)" do
      move = subject.start(double_step)
      expect(move).to eq 2
    end
  end
end