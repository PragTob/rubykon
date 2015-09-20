module Rubykon
  class Group

    attr_reader :liberty_count

    def self.assign(stone, board)
      neighbours = board.neighbours_of(stone.x, stone.y)
      neighbours_by_color = neighbours.group_by &:color
      neighbours_by_color.default = []

      neighbours_by_color[stone.color].each do |friendly_stone|
        friendly_stone.group.add(stone)
      end

      stone.join(new(stone)) unless stone.group
      group = stone.group

      neighbours_by_color[Board::EMPTY_COLOR].each do |field|
        # if we never created new stones we could use object identity here...
        # which would break once we ever copy a board... er could try never
        # copying a board but then we'd have to restore board state which is
        # prone to fail badly
        group.add_liberty(field)
      end

      neighbours_by_color[stone.enemy_color].each do |stone|
        group.remove_liberty(stone) # and here too...
      end

    end

    def initialize(stone)
      @liberties = {}
      @liberty_count = 0
      @stones = [stone]
    end

    def add_stone(x, y, stone)

    end

    def add_liberty(field)

    end

    def remove
      @stones.each &:remove
      notify_neighbouring_groups
    end
  end
end