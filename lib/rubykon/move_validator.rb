module Rubykon
  class MoveValidator
    
    def validate(move, board)
      validate_move_on_board(move, board) && spot_unoccupied(move, board)
    end
    
    
    def validate_move_on_board(move, board)
      (move.x >= 1) && (move.y >= 1) && 
      (move.x <= board.size) && (move.y <= board.size)
    end
    
    def spot_unoccupied(move, board)
      board[move.x, move.y] == board.class::EMPTY_SYMBOL
    end
    
  end
end
