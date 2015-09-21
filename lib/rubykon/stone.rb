module Rubykon
  class Stone
    attr_reader :x, :y, :color, :group, :captures

    def initialize(x, y, color)
      @x     = x
      @y     = y
      @color = color
      @group = nil
    end

    def remove
      @group = nil
    end

    def join(group)
      @group = group
    end

    def enemy_color
      if color == :black
        :white
      else
        :black
      end
    end

    def capture(stones)
      @captures ||= []
      @captures += stones
    end

    def empty?
      color == Board::EMPTY_COLOR
    end

    def ==(other_stone)
      (color == other_stone.color) &&
        (x == other_stone.x) &&
        (y == other_stone.y)
    end

    def identifier
      "#{x}-#{y}".freeze
    end
  end
end