module Rubykon
  class MoveValidator
    
    def valid?(x, y, color, game)
      board = game.board
      no_double_move?(color, game) &&
        (Stone.pass?(x, y) ||
        (move_on_board?(x, y, board) &&
          spot_unoccupied?(x, y, board) &&
          no_suicide_move?(x, y, color, board) &&
          no_ko_move?(x, y, color, game)))
    end

    private
    def no_double_move?(color, game)
      color == game.next_turn_color
    end

    def move_on_board?(x, y, board)
      board.on_board?(x, y)
    end
    
    def spot_unoccupied?(x, y, board)
      board[x, y] == Board::EMPTY
    end

    def no_suicide_move?(x, y, color, board)
      enemy_color == Stone.other_color(color)
      board.neighbours_of(x, y).any? do |n_x, n_y, n_color|
        (n_color == Board::EMPTY) ||
          (n_color == color) && (liberties_at(x, y, board) > 1) ||
          (n_color == enemy_color) && (liberties_at(x, y, board) <= 1)
      end
    end


    # we have to do a big fat revisit on Ko...
    KO_MIN_MOVES = 4 # good gut feeling that there at least need to be that many
    def no_ko_move?(x, y, color, game)
      moves = game.moves
      return true unless ko_possible?(moves)
      last_capture = moves.last.captures.first
      not(last_capture == x, y, color)
    end

    def ko_possible?(moves)
      (moves.size >= KO_MIN_MOVES) && (moves.last.captures) && (moves.last.captures.size == 1)
    end
  end
end
