require_relative 'spec_helper'
module Rubykon
  describe Board do

    let(:board) {Board.new(19)}

    context 'setting and retrieving LOOKUP' do
      it 'has the empty symbol for every LOOKUP' do
        all_empty = board.all? do |field|
          field.color == Board::EMPTY
        end
        expect(all_empty).to be true
      end

      it 'can retrive the empty values via #[]' do
        expect(board[1, 1].color).to eq Board::EMPTY
      end

      it "gives the initially set stones the right coordinates" do
        expect(board[1, 1]).to eq Stone.new 1, 1, Board::EMPTY
        expect(board[1, 7]).to eq Stone.new 1, 7, Board::EMPTY
        expect(board[7, 1]).to eq Stone.new 7, 1, Board::EMPTY
        expect(board[19, 19]).to eq Stone.new 19, 19, Board::EMPTY
        expect(board[3, 5]).to eq Stone.new 3, 5, Board::EMPTY
      end

      it 'can set values with []= and geht them with []' do
        board[1, 1] = :test
        expect(board[1, 1]).to be :test
      end
    end

    describe "#set" do
      it "sets to the right coordinates" do
        stone = Stone.new(3, 7, :black)
        board.set(stone)
        expect(board[3, 7]).to be stone
      end
    end

    describe "#neighbours_of and neighbour_colors_of" do
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
                                            Stone.new(2, 3, Board::EMPTY))
        expect(board.neighbour_colors_of(2, 2)).to contain_exactly(
                                                    :black, :black, :white,
                                                    Board::EMPTY)
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
                                            Stone.new(1, 1, Board::EMPTY))
        expect(board.neighbour_colors_of(2, 1)).to contain_exactly(
                                                     :black, :white,
                                                     Board::EMPTY)
      end

      it "returns fewer stones when in the corner" do
        board = Rubykon::Board.from <<-String
-X-
---
---
        String
        expect(board.neighbours_of(1, 1)).to contain_exactly(
                                           Stone.new(2, 1, :black),
                                           Stone.new(1, 2, Board::EMPTY))
        expect(board.neighbour_colors_of(1, 1)).to contain_exactly(
                                                     :black, Board::EMPTY)
      end
    end

    describe "#diagonal_colors_of" do
      it "returns the colors in the diagonal fields" do
        board = Board.from <<-BOARD
O-X
---
X--
        BOARD
        expect(board.diagonal_colors_of(2, 2)).to contain_exactly :white,
                                                                  :black,
                                                                  :black,
                                                                  Board::EMPTY
      end

      it "does not contain the neighbors" do
        board = Board.from <<-BOARD
-X-
O-X
-O-
        BOARD
        expect(board.diagonal_colors_of(2, 2)).to contain_exactly Board::EMPTY,
                                                                  Board::EMPTY,
                                                                  Board::EMPTY,
                                                                  Board::EMPTY
      end

      it "works on the edge" do
        board = Board.from <<-BOARD
---
O-X
---
        BOARD
        expect(board.diagonal_colors_of(2, 1)).to contain_exactly :white,
                                                                  :black
      end

      it "works in the corner" do
        board = Board.from <<-BOARD
---
-X-
---
        BOARD
        expect(board.diagonal_colors_of(1, 1)).to contain_exactly :black
      end
    end

    describe "on_edge?" do
      let(:board) {Board.new 5}

      it "is false for coordinates close to the edge" do
        expect(board.on_edge?(2, 2)).to be_falsey
        expect(board.on_edge?(4, 4)).to be_falsey
      end

      it "is true if one coordinate is 1" do
        expect(board.on_edge?(1, 3)).to be_truthy
        expect(board.on_edge?(2, 1)).to be_truthy
        expect(board.on_edge?(1, 1)).to be_truthy
      end

      it "is true if one coordinate is boardsize" do
        expect(board.on_edge?(2, 5)).to be_truthy
        expect(board.on_edge?(5, 1)).to be_truthy
        expect(board.on_edge?(5, 5)).to be_truthy
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