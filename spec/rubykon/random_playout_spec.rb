require_relative 'spec_helper'

module Rubykon
  RSpec.describe RandomPlayout do
    let(:original_game) {Game.new 19}
    let(:playouter) {described_class.new}

    describe "#play" do
      it "returns some score" do
        result = playouter.play original_game
        expect(result[:black]).to be > 0
        expect(result[:white]).to be > 0
      end
    end

    describe "#playout_for" do
      let!(:played_out) {playouter.playout_for(original_game)}

      it "sets a lot of moves... " do
        expect(played_out.move_count).to be >= 150
      end

      describe "not modifying the original" do
        it "makes no moves" do
          expect(original_game.no_moves_played?).to be_truthy
        end

        it "the associated board is empty" do
          board_empty = original_game.board.all? do |id, color|
            color == Board::EMPTY
          end
          expect(board_empty).to be_truthy
        end
      end
    end
  end
end