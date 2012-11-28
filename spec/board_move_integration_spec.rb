require_relative 'spec_helper'

Board                = Rubykon::Board
Move                 = Rubykon::Move
IllegalMoveException = Rubykon::IllegalMoveException
MoveFactory          = Rubykon::SpecHelpers::MoveFactory

SIMPLE_X             = 1
SIMPLE_Y             = 1
SIMPLE_COLOR         = :black
BOARD_SIZE           = 19

describe 'Playing moves on a board:' do

  before :each do
    @board = Board.new BOARD_SIZE
  end
  
  describe 'A simple move' do
    before :each do
      @move = Move.new SIMPLE_X, SIMPLE_Y, SIMPLE_COLOR
      @board.play @move
    end
    
    it 'lets the board retrieve the color of the move at that position' do
      @board[SIMPLE_X, SIMPLE_Y].should eq @move.color
    end
    
    it 'sets the move_count to 1' do
      @board.move_count.should eq 1
    end
    
    it 'should have played moves' do
      @board.should_not be_no_moves_played
    end
    
    it 'can retrieve the played move through moves' do
      @board.moves.first.should eq @move
    end
    
    it 'returns a truthy value' do
      legal_move = MoveFactory.build x: SIMPLE_X + 2 #slightly different to avoid conflicts 
      @board.play(legal_move).should == true 
    end
  end
  
  describe 'A couple of moves' do
    before :each do
      move_1 = MoveFactory.build x: 3, y: 7, color: :black
      move_2 = MoveFactory.build x: 5, y: 7, color: :white
      move_3 = MoveFactory.build x: 3, y: 10, color: :black
      @moves = [move_1, move_2, move_3]
      @moves.each{|move| @board.play move}
    end
    
    it 'sets the move_count to the number of moves played' do
      @board.move_count.should eq @moves.size
    end
    
    it 'remembers the moves in the correct order' do
      @board.moves.should eq @moves
    end
  
  end
  
  describe 'Illegal moves' do
    # more specs about which move is invalid and which is invalid can be found
    # in the move_validator_spec since this is the responsible component
    it 'is illegal to play moves with a greater x than the board size' do
      illegal_move = Move.new BOARD_SIZE + 1, SIMPLE_Y, SIMPLE_COLOR
      @board.play(illegal_move).should == false
    end
    
    it 'is illegal to play moves with a greater y than the board size' do
      illegal_move = Move.new SIMPLE_X, BOARD_SIZE + 1, SIMPLE_COLOR
      @board.play(illegal_move).should == false
    end
  end

end
