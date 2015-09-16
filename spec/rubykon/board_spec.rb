require_relative 'spec_helper'

describe Rubykon::Board do
  
  let(:board) {Rubykon::Board.new}
  
  context 'creation' do
    subject {board}
    it {is_expected.not_to be_nil}
    
    it 'has a default size of 19' do
      expect(board.size).to eq(19)
    end
    
    it 'has a move_count of 0' do
      expect(board.move_count).to eq 0
    end
    
    it 'has no moves playd' do
      expect(board).to be_no_stones_played
    end
    
    it 'can be created with another size' do
      size = 13
      expect(Rubykon::Board.new(size).size).to eq size
    end
  end
  
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

  describe 'to_string' do
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
      move = Rubykon::Stone.new 4, 4, :black
      board.play move
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
      board.play Rubykon::Stone.new 4, 4, :white
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
      board.play Rubykon::Stone.new 1, 1, :white
      board.play Rubykon::Stone.new 7, 7, :black
      board.play Rubykon::Stone.new 1, 7, :white
      board.play Rubykon::Stone.new 7, 1, :black
      board.play Rubykon::Stone.new 5, 5, :white
      board.play Rubykon::Stone.new 3, 3, :black

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
