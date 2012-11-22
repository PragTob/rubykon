module Rubykon
  class MoveValidator
    
    def validate(move, board)
      validate_move_coordinates(move)
    end
    
    def validate_move_coordinates(move)
      (move.x > 0) && (move.y > 0) 
    end
  end
end
