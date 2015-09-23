module Rubykon
  class MoveValidator
    
    def valid?(move, game)
      board = game.board
      no_double_move?(move, game) &&
        (move.pass? ||
        (move_on_board?(move, board) &&
          spot_unoccupied?(move, board) &&
          no_suicide_move?(move, board)))
    end

    private
    def no_double_move?(move, game)
      game.moves.empty? || (game.moves.last.color != move.color)
    end

    def move_on_board?(move, board)
      board.on_board?(move.x, move.y)
    end
    
    def spot_unoccupied?(move, board)
      board[move.x, move.y].color == Board::EMPTY_COLOR
    end

    def no_suicide_move?(move, board)
      neighbours = board.neighbours_of(move.x, move.y)
      is_capturing_stones?(move, neighbours) || has_liberties?(move, neighbours)
    end

    def is_capturing_stones?(move, neighbours)
      neighbours.any? do |stone|
        (stone.color == move.enemy_color) && (stone.group.liberty_count <= 1)
      end
    end

    def has_liberties?(move, neighbours)
      neighbours.any? do |stone|
        (stone.color == Board::EMPTY_COLOR) ||
          ((stone.color == move.color) && (stone.group.liberty_count > 1))
      end
    end
    
  end
end
