module Rubykon
  class Stone
    attr_reader :x, :y, :color, :group, :captures

    def initialize(x, y, color, group = nil)
      @x     = x
      @y     = y
      @color = color
      @group = group
    end

    def remove
      @group = nil
    end

    def join(group)
      @group = group
    end

    def self.other_color(color)
      if color == :black
        :white
      else
        :black
      end
    end

    def enemy_color
      self.class.other_color(color)
    end

    def capture(stones)
      @captures ||= []
      @captures += stones
    end

    def empty?
      color == Board::EMPTY
    end

    def self.pass?(identifier)
      identifier.nil?
    end

    def ==(other_stone)
      (color == other_stone.color) &&
        (x == other_stone.x) &&
        (y == other_stone.y)
    end

    def identifier
      "#{x}-#{y}".freeze
    end

    def dup
      # group is dupped elsewhere as it references stone...
      self.class.new x, y, color, @group
    end
  end
end