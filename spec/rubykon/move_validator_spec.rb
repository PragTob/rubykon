require_relative 'spec_helper'

DEFAULT_BOARD_SIZE  = 19


describe Rubykon::MoveValidator do
  
  let(:validator) {Rubykon::MoveValidator.new}
  let(:board) {Rubykon::Board.new DEFAULT_BOARD_SIZE}

  it 'can be created' do
    expect(validator).not_to be_nil
  end
  
  describe 'legal moves' do
    it 'is accepts normal moves' do
      should_be_valid_move Rubykon::StoneFactory.build, board
    end
    
    it 'accepts 1-1' do
      should_be_valid_move (Rubykon::StoneFactory.build x: 1, y: 1), board
    end
    
    it 'accepts the move in the top right corner (19-19)' do
      should_be_valid_move Rubykon::StoneFactory.build(x: DEFAULT_BOARD_SIZE,
                                                       y: DEFAULT_BOARD_SIZE),
                            board
    end
    
    it 'accepts a different color' do
      should_be_valid_move (Rubykon::StoneFactory.build color: :white), board
    end
    
    it 'also works correctly with bigger boards' do
      board = Rubykon::Board.new 37
      should_be_valid_move (Rubykon::StoneFactory.build x: 37, y: 37), board
    end
    
  end
  
  describe 'Moves illegal of their own' do
    it 'is illegal with negative x and y' do
      move = Rubykon::StoneFactory.build x: -3, y: -4
      should_be_invalid_move move, board
    end
    
    it 'is illegal with negative x' do
      move = Rubykon::StoneFactory.build x: -1
      should_be_invalid_move move, board
    end
    
    it 'is illegal with negative y' do
      move = Rubykon::StoneFactory.build y: -1
      should_be_invalid_move move, board
    end
    
    it 'is illegal with x set to 0' do
      move = Rubykon::StoneFactory.build x: 0
      should_be_invalid_move move, board
    end
    
    it 'is illegal with y set to 0' do
      move = Rubykon::StoneFactory.build y: 0
      should_be_invalid_move move, board
    end
  end
  
  describe 'Moves illegal in the context of a board' do
    it 'is illegal with x bigger than the board size' do
      move = Rubykon::StoneFactory.build x: DEFAULT_BOARD_SIZE + 1
      should_be_invalid_move move, board
    end
    
    it 'is illegal with y bigger than the board size' do
      move = Rubykon::StoneFactory.build y: DEFAULT_BOARD_SIZE + 1
      should_be_invalid_move move, board
    end
    
    it 'is illegal to set a stone at a position already occupied by a stone' do
      move = Rubykon::StoneFactory.build x: 1, y: 1
      board.play move
      should_be_invalid_move move, board
    end
    
    it 'also works for other board sizes' do
      board = Rubykon::Board.new 5
      should_be_invalid_move (Rubykon::StoneFactory.build x: 6), board
    end
  end
  
  describe 'KO' do

    let(:board) {setup_ko_board}
    let(:move_2_2) {Rubykon::StoneFactory.build x: 2, y: 2, color: :white}

    it 'is a valide move for white at 2-2' do
      should_be_valid_move move_2_2, board
    end
    
    it 'is an invalid move to catch back for black after white played 2-2' do
      skip 'woops need to implement catching stones first'
      board.play move_2_2
      should_be_invalid_move Rubykon::StoneFactory.build(x: 2, y: 3, color: :black), board
    end
    
  end

  def should_be_invalid_move move, board
    move_validate_should_return(false, move, board)
  end

  def should_be_valid_move move, board
    move_validate_should_return(true, move, board)
  end

  def move_validate_should_return(bool, move, board)
    expect(validator.validate(move, board)).to be bool
  end

  def setup_ko_board
    board = Rubykon::Board.new 5
    board = black_star board
    white_half_star board
  end

  def black_star(board)
    board[2, 1] = :black
    board[1, 2] = :black
    board[2, 3] = :black
    board[3, 2] = :black
    board
  end

  def white_half_star(board)
    board[3,1] = :white
    board[4,2] = :white
    board[3,4] = :white
    board
  end

end
