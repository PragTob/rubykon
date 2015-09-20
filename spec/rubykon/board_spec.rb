require_relative 'spec_helper'
module Rubykon
  describe Board do

    let(:board) {Board.new(19)}

    context 'setting and retrieving LOOKUP' do
      it 'has the empty symbol for every LOOKUP' do
        all_empty = board.all? do |field|
          field.color == Board::EMPTY_COLOR
        end
        expect(all_empty).to be true
      end

      it 'can retrive the empty values via #[]' do
        expect(board[1, 1].color).to eq Board::EMPTY_COLOR
      end

      it "gives the initially set stones the right coordinates" do
        expect(board[1, 1]).to eq Stone.new 1, 1, Board::EMPTY_COLOR
        expect(board[1, 7]).to eq Stone.new 1, 7, Board::EMPTY_COLOR
        expect(board[7, 1]).to eq Stone.new 7, 1, Board::EMPTY_COLOR
        expect(board[19, 19]).to eq Stone.new 19, 19, Board::EMPTY_COLOR
        expect(board[3, 5]).to eq Stone.new 3, 5, Board::EMPTY_COLOR
      end

      it 'can set values with []= and geht them with []' do
        board[1, 1] = :test
        expect(board[1, 1]).to be :test
      end
    end

    describe "#neighbours_of" do
      it "returns the stones of the neighbouring fields" do
        board = Rubykon::Board.from <<-String
-X-
O-X
---
        String
        expect(board.neighbours_of(2, 2)).to contain_exactly(
                                            Stone.new(2, 1, :black),
                                            Stone.new(3, 2, :black),
                                            Stone.new(1, 2, :white),
                                            Stone.new(2, 3, Board::EMPTY_COLOR))
      end


      it "returns fewer stones when on the edge" do
        board = Rubykon::Board.from <<-String
--X
-O-
---
        String
        expect(board.neighbours_of(2, 1)).to contain_exactly(
                                            Stone.new(3, 1, :black),
                                            Stone.new(2, 2, :white),
                                            Stone.new(1, 1, Board::EMPTY_COLOR))
      end

      it "returns fewer stones when in the corner" do
        board = Rubykon::Board.from <<-String
-X-
---
---
        String
        expect(board.neighbours_of(1, 1)).to contain_exactly(
                                           Stone.new(2, 1, :black),
                                           Stone.new(1, 2, Board::EMPTY_COLOR))
      end
    end

    describe '#==' do
      it "is true for two empty boards" do
        expect(Rubykon::Board.new(5) == Rubykon::Board.new(5)).to be true
      end

      it "is false when the board size is different" do
        expect(Rubykon::Board.new(6) == Rubykon::Board.new(5)).to be false
      end

      it "is equal to itself" do
        board = Rubykon::Board.new 5
        expect(board == board).to be true
      end

      it "is false if one of the boards has a move played" do
        board = Rubykon::Board.new 5
        other_board = Rubykon::Board.new 5
        board[1, 1] = Rubykon::StoneFactory.build
        expect(board == other_board).to be false
      end

      it "is true if both boards has a move played" do
        board = Rubykon::Board.new 5
        other_board = Rubykon::Board.new 5
        board[1, 1] = Rubykon::StoneFactory.build
        other_board[1, 1] = Rubykon::StoneFactory.build
        expect(board == other_board).to be true
      end

      it "is false if both boards have a move played but different colors" do
        board = Rubykon::Board.new 5
        other_board = Rubykon::Board.new 5
        board[1, 1] = Rubykon::StoneFactory.build color: :white
        other_board[1, 1] = Rubykon::StoneFactory.build color: :black
        expect(board == other_board).to be false
      end
    end

    describe '#String conversions' do
      let(:board) {Rubykon::Board.new 7}

      it "correctly outputs an empty board" do
        expected = <<-BOARD
-------
-------
-------
-------
-------
-------
-------
        BOARD

        board_string = board.to_s
        expect(board_string).to eq expected
        expect(Rubykon::Board.from board_string).to eq board
      end

      it "correctly outputs a board with a black move" do
        board[4, 4] = Rubykon::Stone.new 4, 4, :black
        expected = <<-BOARD
-------
-------
-------
---X---
-------
-------
-------
        BOARD
        board_string = board.to_s
        expect(board_string).to eq expected
        expect(Rubykon::Board.from board_string).to eq board
      end

      it "correctly outputs a board with a white move" do
        board[4, 4] = Rubykon::Stone.new 4, 4, :white
        expected = <<-BOARD
-------
-------
-------
---O---
-------
-------
-------
        BOARD
        board_string = board.to_s
        expect(board_string).to eq expected
        expect(Rubykon::Board.from board_string).to eq board
      end

      it "correctly outputs multiple moves played" do
        board[1, 1] = Rubykon::Stone.new 1, 1, :white
        board[7, 7] = Rubykon::Stone.new 7, 7, :black
        board[1, 7] = Rubykon::Stone.new 1, 7, :white
        board[7, 1] = Rubykon::Stone.new 7, 1, :black
        board[5, 5] = Rubykon::Stone.new 5, 5, :white
        board[3, 3] = Rubykon::Stone.new 3, 3, :black

        expected = <<-BOARD
O-----X
-------
--X----
-------
----O--
-------
O-----X
        BOARD
        board_string = board.to_s
        expect(board_string).to eq expected
        expect(Rubykon::Board.from board_string).to eq board
      end

    end

  end
end