module Rubykon
  class MoveValidator
    
    def valid?(move, game)
      board = game.board
      no_double_move?(move, game) &&
        (move.pass? ||
        (move_on_board?(move, board) &&
          spot_unoccupied?(move, board) &&
          no_suicide_move?(move, board) &&
          no_ko_move?(move, game)))
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

    KO_MIN_MOVES = 4 # good gut feeling that there at least need to be that many

    def no_ko_move?(move, game)
      moves = game.moves
      return true unless ko_possible?(moves)
      last_capture = moves.last.captures.first
      not(last_capture == move)
    end

    def ko_possible?(moves)
      (moves.size >= KO_MIN_MOVES) && (moves.last.captures) && (moves.last.captures.size == 1)
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
