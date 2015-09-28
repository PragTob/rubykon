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
      tries = 0
      size  = game.board.size
      cp_count   = size * size
      max_tries = cp_count * MAX_TRIES_MODIFIER
      move = random_move(color, cp_count)
      until plausible_move?(*move, game) do
        tries += 1
        move =  if tries <= max_tries
                  random_move(color, cp_count)
                else
                  pass_move(color)
                end
      end
      move
    end

    def pass_move(color)
      [nil, color]
    end

    def random_move(color, cp_count)
      [rand(cp_count), color]
    end

    def plausible_move?(identifier, color, game)
      return true if Game.pass?(identifier)
      @validator.valid?(identifier, color, game) &&
        !@eye_detector.is_eye?(identifier, game.board)
    end
  end
end