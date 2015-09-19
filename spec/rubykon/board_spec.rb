require_relative 'spec_helper'

describe Rubykon::Board do
  
  let(:board) {Rubykon::Board.new(19)}
  
  context 'setting and retrieving LOOKUP' do
    it 'has the empty symbol for every LOOKUP' do
      all_empty = board.all? do |cutting_point|
        cutting_point == Rubykon::Board::EMPTY_SYMBOL
      end
      expect(all_empty).to be true
    end
    
    it 'can retrive the empty values via #[]' do
      expect(board[1, 1]).to be Rubykon::Board::EMPTY_SYMBOL
    end
    
    it 'can set values with []= and geht them with []' do
      board[1, 1] = :test
      expect(board[1, 1]).to be :test 
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

  describe '#String coversions' do
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
      board[4, 4] = Rubykon::StoneFactory.build x: 4, y: 4, color: :black
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
      board[4, 4] = Rubykon::StoneFactory.build x: 4, y: 4, color: :white
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
      board[1, 1] = Rubykon::StoneFactory.build x: 1, y: 1, color: :white
      board[7, 7] = Rubykon::StoneFactory.build x: 7, y: 7, color: :black
      board[1, 7] = Rubykon::StoneFactory.build x: 1, y: 7, color: :white
      board[7, 1] = Rubykon::StoneFactory.build x: 7, y: 1, color: :black
      board[5, 5] = Rubykon::StoneFactory.build x: 5, y: 5, color: :white
      board[3, 3] = Rubykon::StoneFactory.build x: 3, y: 3, color: :black

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
