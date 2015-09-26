module Rubykon
  class RandomPlayout

    MAX_TRIES_MODIFIER = 2

    def initialize
      @validator    = MoveValidator.new
      @eye_detector = EyeDetector.new
    end

    def play(game)
      playout_for(game)
      score(game)
    end

    def score(game)
      scorer = GameScorer.new
      scorer.score(game)
    end

    def playout_for(original_game)
      game = original_game.dup
      until game.finished?
        # we ensure the validity of the move
        game.set_valid_move generate_random_move(game)
      end
      game
    end

    private
    # Move generation as a lazy iterator?
    def generate_random_move(game)
      color = game.next_turn_color
      tries = 0
      size  = game.board.size
      max_tries = size * size * MAX_TRIES_MODIFIER
      move = random_move(color, size)
      until plausible_move?(move, game) do
        tries += 1
        move =  if tries <= max_tries
                  random_move(color, size)
                else
                  pass_move(color)
                end
      end
      move
    end

    def pass_move(color)
      Stone.new nil, nil, color
    end

    def random_move(color, size)
      Stone.new(rand(size) + 1, rand(size) + 1, color)
    end

    def plausible_move?(move, game)
      return true if move.pass?
      @validator.valid?(move, game) &&
        !@eye_detector.is_eye?(move.x, move.y, game.board)
    end
  end
end