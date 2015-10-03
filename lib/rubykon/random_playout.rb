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
      range = game.board[start_point..-1] + game.board[0..start_point]
      _color, identifier = range.each_with_index.find do |field_color,
        identifier|
        (field_color == Board::EMPTY) && plausible_move?((identifier + start_point) % cp_count, color, game)
      end
      if identifier.nil?
        [identifier, color]
      else
        [(identifier + start_point) % cp_count, color]
      end
    end

    def pass_move(color)
      [nil, color]
    end

    def random_move(cp_count)
      rand(cp_count)
    end

    def plausible_move?(identifier, color, game)
      return true if Game.pass?(identifier)
      @validator.valid?(identifier, color, game) &&
        !@eye_detector.is_eye?(identifier, game.board)
    end
  end
end