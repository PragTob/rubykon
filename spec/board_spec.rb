require_relative 'spec_helper'

describe Rubykon::Board do
  
  let(:board) {Rubykon::Board.new}
  
  context 'creation' do
    subject {board}
    it {should_not be_nil}
    
    it 'has a default size of 19' do
      board.size.should == 19
    end
    
    it 'has a move_count of 0' do
      board.move_count.should eq 0
    end
    
    it 'has no moves playd' do
      board.should be_no_stones_played
    end
    
    it 'can be created with another size' do
      size = 13
      Rubykon::Board.new(size).size.should eq size
    end
  end
  
  context 'setting and retrieving LOOKUP' do
    it 'has the empty symbol for every LOOKUP' do
      all_empty = true
      board.each do |cutting_point|
        all_empty = false if cutting_point != Rubykon::Board::EMPTY_SYMBOL
      end
      all_empty.should be true
    end
    
    it 'can retrive the empty values via #[]' do
      board[1, 1].should be Rubykon::Board::EMPTY_SYMBOL
    end
    
    it 'can set values with []= and geht them with []' do
      board[1, 1] = :test
      board[1, 1].should be :test 
    end
  end   
   
end
