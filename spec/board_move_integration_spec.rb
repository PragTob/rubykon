require_relative 'spec_helper'

Board                = Rubykon::Board
Move                 = Rubykon::Move
IllegalMoveException = Rubykon::IllegalMoveException

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
  end
  
  describe 'Illegal moves' do
    # more specs about which move is invalid and which is invalid can be found
    # in the move_validator_spec since this is the responsible component
    it 'is illegal to play moves with a greater x than the board size' do
      illegal_move = Move.new BOARD_SIZE + 1, SIMPLE_Y, SIMPLE_COLOR
      expect do @board.play illegal_move end.to raise_error IllegalMoveException
    end
    
    it 'is illegal to play moves with a greater y than the board size' do
      illegal_move = Move.new SIMPLE_X, BOARD_SIZE + 1, SIMPLE_COLOR
      expect do @board.play illegal_move end.to raise_error IllegalMoveException
    end
  end

end
