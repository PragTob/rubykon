require_relative 'spec_helper'

MoveValidator = Rubykon::MoveValidator
MoveFactory   = Rubykon::SpecHelpers::MoveFactory
Board         = Rubykon::Board

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
      @board = Board.new DEFAULT_BOARD_SIZE
    end
    
  end
  
  describe 'Moves illegal of their own' do
    before :each do
      @board = mock :board
    end
    
    it 'is illegal with negative x and y' do
      move = MoveFactory.build x: -3, y: -4
      should_be_invalid_move move, @board
    end
    
    it 'is illegal with negative x' do
      move = MoveFactory.build x: -1
      should_be_invalid_move move, @board
    end
    
    it 'is illegal with negative y' do
      move = MoveFactory.build y: -1
      should_be_invalid_move move, @board
    end
    
    it 'is illegal with x set to 0' do
      move = MoveFactory.build x: 0
      should_be_invalid_move move, @board
    end
    
    it 'is illegal with y set to 0' do
      move = MoveFactory.build y: 0
      should_be_invalid_move move, @board
    end
  end
  
  describe 'Moves illegal in the context of a board' do
    before :each do
      @board = Board.new DEFAULT_BOARD_SIZE
    end
    
    it 'is illegal with x bigger than the board size' do
      move = MoveFactory.build x: DEFAULT_BOARD_SIZE + 1
      should_be_invalid_move move, @board
    end
    
    it 'is illegal with y bigger than the board size' do
      move = MoveFactory.build y: DEFAULT_BOARD_SIZE + 1
      should_be_invalid_move move, @board
    end
    
    it 'is illegal to set a stone at a position already occupied by a stone' do
      move = MoveFactory.build x: 1, y: 1
      @board.play move
      should_be_invalid_move move, @board
    end
    
  end


end
