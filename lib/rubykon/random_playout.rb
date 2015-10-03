module Rubykon
  class RandomPlayout

    MAX_TRIES_MODIFIER = 2

    def initialize
      @validator    = MoveValidator.new
      @eye_detector = EyeDetector.new
    end

    def play(game)
      played_out_game = playout_for(game)
      score(played_out_game)
    end

    def score(game)
      scorer = GameScorer.new
      scorer.score(game)
    end

    def playout_for(original_game)
      game = original_game.dup
      until game.finished?
        # we ensure the validity of the move
        game.set_valid_move *generate_random_move(game)
      end
      game
    end

    private
    # Move generation as a lazy iterator?
    def generate_random_move(game)
      color = game.next_turn_color
      size  = game.board.size
      cp_count   = size * size
      start_point = rand(cp_count)
      identifier = start_point
      passes = 0

      until searched_whole_board?(identifier, passes, start_point) ||
        plausible_move?(identifier, color, game) do
        if identifier > cp_count
          identifier = 0
          passes += 1
        else
          identifier += 1
        end
      end

      if searched_whole_board?(identifier, passes, start_point)
        pass_move(color)
      else
        [identifier, color]
      end
    end

    def searched_whole_board?(identifier, passes, start_point)
      passes > 0 && identifier >= start_point
    end

    def pass_move(color)
      [nil, color]
    end

    def random_move(cp_count)
      rand(cp_count)
    end

    def plausible_move?(identifier, color, game)
      @validator.trusted_valid?(identifier, color, game) && !@eye_detector.is_eye?(identifier, game.board)
    end
  end
end