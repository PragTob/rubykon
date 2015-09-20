require_relative 'spec_helper'

module Rubykon
  RSpec.describe Rubykon::Game do
    let(:game) {described_class.new}

    context 'creation' do
      subject {game}
      it {is_expected.not_to be_nil}

      it 'has a default size of 19' do
        expect(game.board.size).to eq(19)
      end

      it 'has a move_count of 0' do
        expect(game.move_count).to eq 0
      end

      it 'has no moves playd' do
        expect(game).to be_no_moves_played
      end

      it 'can be created with another size' do
        size = 13
        expect(Rubykon::Game.new(size).board.size).to eq size
      end

      it 'can retrieve the board' do
        expect(game.board).not_to be_nil
      end
    end

    describe ".from" do
      let(:string) do
        <<-GAME
X---O
--X--
X----
-----
-X--O
        GAME
      end

      let(:new_game)  {Game.from string}
      let(:board)     {new_game.board}

      it "sets the right number of moves" do
        expect(new_game.move_count).to eq 6
      end

      it "also populates moves" do
        expect(new_game.moves).not_to be_empty
      end

      it "assigns the stones a group" do
        expect(board[1, 1].group).not_to be_nil
      end

      it "does not assign a group to the empty fields" do
        expect(board[2, 2].group).to be_nil
      end

      it "has stones in all the right places" do
        expect(board[1, 1]).to eq Stone.new 1, 1, :black
        expect(board[5, 1]).to eq Stone.new 5, 1, :white
        expect(board[3, 2]).to eq Stone.new 3, 2, :black
        expect(board[1, 3]).to eq Stone.new 1, 3, :black
        expect(board[2, 5]).to eq Stone.new 2, 5, :black
        expect(board[5, 5]).to eq Stone.new 5, 5, :white
        expect(board[2, 2]).to eq Stone.new 2, 2, Board::EMPTY_COLOR
        expect(board[1, 4]).to eq Stone.new 1, 4, Board::EMPTY_COLOR
      end
    end
  end
end