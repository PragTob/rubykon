module MCTS
  module Examples
    class DoubleStep

      FINAL_POSITION = 6
      MAX_STEP = 2

      attr_reader :positions

      def initialize(positions = init_positions, n = 0)
        @positions = positions
        @move_count = n
      end

      def finished?
        @positions.any? {|_color, position| position >= FINAL_POSITION }
      end

      def generate_move
        rand(MAX_STEP) + 1
      end

      def set_move(move)
        steps = move
        @positions[next_turn_color] += steps
        @move_count += 1
      end

      def dup
        self.class.new @positions.dup, @move_count
      end

      def won?(color)
        fail "Game not finished" unless finished?
        @positions[color] > @positions[other_color(color)]
      end

      def all_valid_moves
        if finished?
          []
        else
          [1, 2]
        end
      end

      def last_turn_color
        @move_count.odd? ? :black : :white
      end

      private
      def next_turn_color
        @move_count.even? ? :black : :white
      end

      def init_positions
        {black: 0, white: 0}
      end

      def other_color(color)
        if color == :black
          :white
        else
          :black
        end
      end
    end
  end
end