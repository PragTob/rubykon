module Rubykon
  class MoveValidator
    
    def valid?(identifier, color, game)
      board = game.board
      no_double_move?(color, game) &&
        (Game.pass?(identifier) ||
        (move_on_board?(identifier, board) &&
          spot_unoccupied?(identifier, board) &&
          no_suicide_move?(identifier, color, game) &&
          no_ko_move?(identifier, game)))
    end

    private
    def no_double_move?(color, game)
      color == game.next_turn_color
    end

    def move_on_board?(identifier, board)
      board.on_board?(identifier)
    end
    
    def spot_unoccupied?(identifier, board)
      board[identifier] == Board::EMPTY
    end

    def no_suicide_move?(identifier, color, game)
      enemy_color = Game.other_color(color)
      board = game.board
      board.neighbours_of(identifier).any? do |n_identifier, n_color|
        (n_color == Board::EMPTY) ||
          (n_color == color) && (liberties_at(n_identifier, game) > 1) ||
          (n_color == enemy_color) && (liberties_at(n_identifier, game) <= 1)
      end
    end

    def liberties_at(identifier, game)
      game.group_tracker.group_of(identifier).liberty_count
    end

    def no_ko_move?(identifier, game)
      identifier != game.ko
    end
  end
end
