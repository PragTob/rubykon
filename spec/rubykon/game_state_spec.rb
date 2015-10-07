require_relative 'spec_helper'

module Rubykon
  RSpec.describe GameState do
    let(:original_game) {GameState.new}
    let(:playouter) {MCTS::Playout.new original_game}

    describe "#play" do
      let!(:played_out) do
        playouter.play
        playouter.game_state
      end

      it "gets right scores" do
        result = played_out.score
        expect(result[:black]).to be > 0
        expect(result[:white]).to be > 0
      end


      it "sets a lot of moves... " do
        expect(played_out.game.move_count).to be >= 150
      end

      describe "not modifying the original" do
        it "makes no moves" do
          expect(original_game.game.no_moves_played?).to be_truthy
        end

        it "the associated board is empty" do
          board_empty = original_game.game.board.all? do |_, color|
            color == Board::EMPTY
          end
          expect(board_empty).to be_truthy
        end
      end
    end

    describe "full MCTS playout" do
      let(:original_game) {GameState.new Game.new(9)}
      let(:mcts) {MCTS::MCTS.new}
      let!(:root) {mcts.start(original_game, playouts)}
      let(:playouts) {100}

      it "creates the right number of children" do
        expect(root.children.size).to eq original_game.game.board.cutting_point_count
      end

      it "has some kind of win_percentage" do
        expect(root.win_percentage).to be_between(0, 1).exclusive
      end

      it "has 500 visits" do
        expect(root.visits).to eq playouts
      end

      it "can select the best move" do
        expect(root.best_move).not_to be_nil
      end

      it "does not touch the original game" do
        expect(original_game.game.move_count).to eq 0
      end
    end

  end
end