require_relative 'spec_helper'

describe Rubykon::MoveValidator do
  
  let(:validator) {Rubykon::MoveValidator.new}
  let(:board_size) {19}
  let(:game) {Rubykon::Game.new board_size}
  let(:baord) {game.board}

  it 'can be created' do
    expect(validator).not_to be_nil
  end
  
  describe 'legal moves' do
    it 'is accepts normal moves' do
      should_be_valid_move Rubykon::MoveFactory.build, game
    end
    
    it 'accepts 1-1' do
      should_be_valid_move (Rubykon::MoveFactory.build x: 1, y: 1), game
    end
    
    it 'accepts the move in the top right corner (19-19)' do
      should_be_valid_move Rubykon::MoveFactory.build(x: board_size,
                                                       y: board_size),
                            game
    end
    
    it 'accepts a different color' do
      should_be_valid_move (Rubykon::MoveFactory.build color: :white), game
    end
    
    it 'also works correctly with bigger boards' do
      game = Rubykon::Game.new 37
      should_be_valid_move (Rubykon::MoveFactory.build x: 37, y: 37), game
    end
    
  end
  
  describe 'Moves illegal of their own' do
    it 'is illegal with negative x and y' do
      move = Rubykon::MoveFactory.build x: -3, y: -4
      should_be_invalid_move move, game
    end
    
    it 'is illegal with negative x' do
      move = Rubykon::MoveFactory.build x: -1
      should_be_invalid_move move, game
    end
    
    it 'is illegal with negative y' do
      move = Rubykon::MoveFactory.build y: -1
      should_be_invalid_move move, game
    end
    
    it 'is illegal with x set to 0' do
      move = Rubykon::MoveFactory.build x: 0
      should_be_invalid_move move, game
    end
    
    it 'is illegal with y set to 0' do
      move = Rubykon::MoveFactory.build y: 0
      should_be_invalid_move move, game
    end
  end
  
  describe 'Moves illegal in the context of a board' do
    it 'is illegal with x bigger than the board size' do
      move = Rubykon::MoveFactory.build x: board_size + 1
      should_be_invalid_move move, game
    end
    
    it 'is illegal with y bigger than the board size' do
      move = Rubykon::MoveFactory.build y: board_size + 1
      should_be_invalid_move move, game
    end
    
    it 'is illegal to set a stone at a position already occupied by a stone' do
      move = Rubykon::MoveFactory.build x: 1, y: 1
      game.play move
      should_be_invalid_move move, game
    end
    
    it 'also works for other board sizes' do
      game = Rubykon::Game.new 5
      should_be_invalid_move (Rubykon::MoveFactory.build x: 6), game
    end
  end
  
  describe 'KO' do

    let(:game) {setup_ko_board}
    let(:move_2_2) {Rubykon::MoveFactory.build x: 2, y: 2, color: :white}

    it 'is a valide move for white at 2-2' do
      should_be_valid_move move_2_2, game
    end
    
    it 'is an invalid move to catch back for black after white played 2-2' do
      skip 'woops need to implement catching stones first'
      game.play move_2_2
      should_be_invalid_move Rubykon::MoveFactory.build(x: 2, y: 3, color: :black), game
    end
    
  end

  def should_be_invalid_move(move, game)
    move_validate_should_return(false, move, game)
  end

  def should_be_valid_move(move, game)
    move_validate_should_return(true, move, game)
  end

  def move_validate_should_return(bool, move, game)
    expect(validator.validate(move, game)).to be bool
  end

  def setup_ko_board
    game = Rubykon::Game.new 5
    board = game.board
    board = black_star board
    white_half_star board
    game
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
