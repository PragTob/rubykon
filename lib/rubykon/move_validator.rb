module Rubykon
  class MoveValidator
    
    def valid?(move, game)
      board = game.board
      move_on_board?(move, board) && spot_unoccupied?(move, board)
    end
    
    
    def move_on_board?(move, board)
      board.on_board?(move.x, move.y)
    end
    
    def spot_unoccupied?(move, board)
      board[move.x, move.y].color == Board::EMPTY_COLOR
    end
    
  end
end
