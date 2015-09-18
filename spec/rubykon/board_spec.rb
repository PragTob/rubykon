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

  describe '#to_string' do
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

      expect(board.to_s).to eq expected
    end

    it "correctly outputs a board with a black move" do
      board[4, 4] = :black
      expected = <<-BOARD
-------
-------
-------
---X---
-------
-------
-------
      BOARD
      expect(board.to_s).to eq expected
    end

    it "correctly outputs a board with a white move" do
      board[4, 4] = :white
      expected = <<-BOARD
-------
-------
-------
---O---
-------
-------
-------
      BOARD
      expect(board.to_s).to eq expected
    end

    it "correctly outputs multiple moves played" do
      board[1, 1] = :white
      board[7, 7] = :black
      board[1, 7] = :white
      board[7, 1] = :black
      board[5, 5] = :white
      board[3, 3] = :black

      expected = <<-BOARD
O-----X
-------
--X----
-------
----O--
-------
O-----X
      BOARD
      expect(board.to_s).to eq expected
    end

  end
   
end
