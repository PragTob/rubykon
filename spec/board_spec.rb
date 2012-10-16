require_relative 'spec_helper'

describe Rubykon::Board do
  context 'creation' do
    subject {Rubykon::Board.new}
    it {should_not be_nil}
    it {should be_empty}
    
    before :each do
      @board = Rubykon::Board.new
    end
    
    it 'has a default size of 19' do
      @board.size.should == 19
    end
    
    it 'can be created with another size' do
      size = 13
      Rubykon::Board.new(size).size.should eq size
    end
  end
end
