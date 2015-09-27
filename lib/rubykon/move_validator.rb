module Rubykon
  class MoveValidator
    
    def valid?(identifier, color, game)
      board = game.board
      no_double_move?(color, game) &&
        (Stone.pass?(identifier) ||
        (move_on_board?(identifier, board) &&
          spot_unoccupied?(identifier, board) &&
          no_suicide_move?(identifier, color, board) &&
          no_ko_move?(identifier, color, game)))
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

    def no_suicide_move?(identifier, color, board)
      enemy_color = Stone.other_color(color)
      board.neighbours_of(identifier).any? do |n_identifier, n_color|
        (n_color == Board::EMPTY) ||
          (n_color == color) && (liberties_at(identifier, board) > 1) ||
          (n_color == enemy_color) && (liberties_at(identifier, board) <= 1)
      end
    end


    # we have to do a big fat revisit on Ko...
    KO_MIN_MOVES = 4 # good gut feeling that there at least need to be that many
    def no_ko_move?(identifier, color, game)
      moves = game.moves
      return true unless ko_possible?(moves)
      last_capture = moves.last.captures.first
      not(last_capture == identifier)
    end

    def ko_possible?(moves)
      (moves.size >= KO_MIN_MOVES) && (moves.last.captures) && (moves.last.captures.size == 1)
    end
  end
end
