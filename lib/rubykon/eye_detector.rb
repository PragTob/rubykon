module Rubykon
  class EyeDetector
    def is_eye?(x, y, board)
      candidate_eye_color = candidate_eye_color(x, y, board)
      return false unless candidate_eye_color
      is_real_eye?(x, y, board, candidate_eye_color)
    end

    private
    def candidate_eye_color(x, y, board)
      neighbor_colors = board.neighbour_colors_of(x, y)
      candidate_eye_color = neighbor_colors.first
      return false if candidate_eye_color == Board::EMPTY
      if neighbor_colors.all? {|color| color == candidate_eye_color}
        candidate_eye_color
      else
        nil
      end
    end

    def is_real_eye?(x, y, board, candidate_eye_color)
      enemy_color = Stone.other_color(candidate_eye_color)
      enemy_count = board.diagonal_colors_of(x, y).count(enemy_color)
      (enemy_count < 1) || (!board.on_edge?(x, y) && enemy_count < 2)
    end
  end
end