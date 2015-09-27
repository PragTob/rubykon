module Rubykon
  class GameScorer
    def score(game)
      game_score = {Board::BLACK => 0, Board::WHITE => game.komi}
      score_board(game, game_score)
      determine_winner(game_score)
      game_score
    end

    private
    def score_board(game, game_score)
      board = game.board
      board.each do |cutting_point|
        if cutting_point.empty?
          score_empty_cutting_point(cutting_point, board, game_score)
        else
          game_score[cutting_point.color] += 1
        end
      end
    end

    def score_empty_cutting_point(cutting_point, board, game_score)
      neighbor_colors = board.neighbour_colors_of(cutting_point.x, cutting_point.y)
      candidate_color = find_candidate_color(neighbor_colors)
      return unless candidate_color
      if only_one_color_adjacent?(neighbor_colors, candidate_color)
        game_score[candidate_color] += 1
      end
    end

    def find_candidate_color(neighbor_colors)
      neighbor_colors.find do |color|
        color != Board::EMPTY
      end
    end

    def only_one_color_adjacent?(neighbor_colors, candidate_color)
      enemy_color = Stone.other_color(candidate_color)
      neighbor_colors.all? do |color|
        color != enemy_color
      end
    end

    def determine_winner(game_score)
      game_score[:winner] = if black_won?(game_score)
                              Board::BLACK
                            else
                              Board::WHITE
                            end
    end

    def black_won?(game_score)
      game_score[Board::BLACK] > game_score[Board::WHITE]
    end
  end
end