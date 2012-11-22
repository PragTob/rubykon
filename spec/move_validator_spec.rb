require_relative 'spec_helper'

MoveValidator = Rubykon::MoveValidator

DEFAULT_X           = 5
DEFAULT_Y           = 7
DEFAULT_BOARD_SIZE  = 19
DEFAULT_COLOR       = :black

def should_be_invalid_move move, board
  move_validate_should_return(false, move, board)
end

def should_be_valid_move move, board
  move_validate_should_return(true, move, board)
end

def move_validate_should_return(bool, move, board)
  @validator.validate(move, board).should be bool
end


describe Rubykon::MoveValidator do

  before :all do
    @validator = MoveValidator.new
  end
  
  it 'can be created' do
    @validator.should_not be_nil
  end
  
  describe 'legal moves' do
    before :each do
      @board = Rubykon::Board.new DEFAULT_BOARD_SIZE
    end
    
  end
  
  describe 'Moves illegal of their own' do
  
    before :each do
      @board = mock :board
    end
    
    it 'is illegal with negative x and y' do
      @move = Move.new -DEFAULT_X, -DEFAULT_Y, DEFAULT_COLOR
      should_be_invalid_move @move, @board
    end
    
    it 'is illegal with negative x' do
      @move = Move.new -DEFAULT_X, DEFAULT_Y, DEFAULT_COLOR
      should_be_invalid_move @move, @board
    end
    
    it 'is illegal with negative y' do
      @move = Move.new DEFAULT_X, -DEFAULT_Y, DEFAULT_COLOR
      should_be_invalid_move @move, @board
    end
    
    it 'is illegal with x set to 0' do
      @move = Move.new 0, -DEFAULT_Y, DEFAULT_COLOR
      should_be_invalid_move @move, @board
    end
    
    it 'is illegal with y set to 0' do
      @move = Move.new DEFAULT_X, 0, DEFAULT_COLOR
      should_be_invalid_move @move, @board
    end
  end


end
