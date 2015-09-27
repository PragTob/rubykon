module Rubykon
  class GroupOverseer

    attr_reader :groups, :stone_to_group, :prisoners

    NOT_SET = :not_set

    def initialize(groups = {}, stone_to_group = {})
      @groups         = groups # group_id to stones, liberty count, liberties
      @stone_to_group = stone_to_group # stone identifier to group identifier
      @prisoners = {Board::BLACK => 0, Board::WHITE => 0}
    end

    def assign(identifier, color, board)
      neighbours_by_color = color_to_neighbour(board, identifier)
      join_group_of_friendly_stones(neighbours_by_color[color], identifier)
      create_own_group(identifier) unless group_id_of(identifier)
      add_liberties(neighbours_by_color[Board::EMPTY], identifier)
      take_liberties_of_enemies(neighbours_by_color[Stone.other_color(color)], identifier, board, color)
    end

    def liberty_count_at(identifier)
      group_of(identifier)[:liberty_count]
    end

    def dup
      self.class.new(@groups.dup, @stone_to_group.dup)
    end

    def group_id_of(identifier)
      @stone_to_group[identifier]
    end

    def group_of(identifier)
      group(group_id_of(identifier))
    end

    def group(id)
      @groups[id]
    end

    private
    def connect(friendly_group_id, stone_identifier)
      stone_group_id = group_id_of(stone_identifier)
      return if stone_group_id == friendly_group_id
      friendly_group = group(friendly_group_id)
      if stone_group_id
        merge(friendly_group_id, stone_group_id)
      else
        add_stone(friendly_group, stone_identifier)
      end
      remove_connector_liberty(friendly_group, stone_identifier)
    end

    def add_liberty(group, identifier)
      return if already_counted_as_liberty?(group, identifier, Board::EMPTY)
      group[:liberties][identifier] = Board::EMPTY
      group[:liberty_count] += 1
    end

    def remove_liberty(group, identifier)
      enemy_group_id = group_id_of identifier
      return if already_counted_as_liberty?(group, identifier, enemy_group_id)
      group[:liberties][identifier] = enemy_group_id
      group[:liberty_count] -= 1
    end

    def caught?(enemy_group)
      enemy_group[:liberty_count] <= 0
    end

    def remove(captured_group, board, capturer_color)
      captured_group[:stones].each do |identifier|
        board[identifier] = Board::EMPTY
        @stone_to_group.delete identifier
      end
      @prisoners[capturer_color] += captured_group[:stones].size
      # we could track that from the start
      neighbouring_group_ids = captured_group[:liberties].values.compact.uniq
      neighbouring_group_ids.each do |neighbor_group_id|
        neighbor_group = group(neighbor_group_id)
        gain_liberties_from_capture_of(neighbor_group, captured_group)
      end
      @groups.delete(captured_group[:id])
    end

    def gain_liberties_from_capture_of(my_group, captured_group)
      new_liberties = my_group[:liberties].select do |_identifier, other_group_id|
        other_group_id == captured_group[:id]
      end
      new_liberties.each do |identifier, _group_id|
        add_liberty(my_group, identifier)
      end
    end

    def remove_connector_liberty(group, identifier)
      group[:liberties].delete(identifier)
      group[:liberty_count] -= 1
    end

    def add_stone(group, identifier)
      @stone_to_group[identifier] = group[:id]
      group[:stones] << identifier
    end

    def already_counted_as_liberty?(group, identifier, group_id)
      group[:liberties].fetch(identifier, NOT_SET) == group_id
    end

    def merge(group_1_id, group_2_id)
      group_1 = group(group_1_id)
      group_2 = group(group_2_id)
      merge_stones(group_1, group_2)
      merge_liberties(group_1, group_2)
    end

    def merge_stones(group_1, group_2)
      group_2[:stones].each { |identifier| add_stone(group_1, identifier) }
    end

    def merge_liberties(group_1, group_2)
      group_1[:liberty_count] += group_2[:liberty_count]
      group_1[:liberties].merge!(group_2[:liberties]) do |_key, my_color, other_color|
        if shared_liberty?(my_color, other_color)
          group_1[:liberty_count] -= 1
        end
        my_color
      end
    end

    def create_own_group(identifier)
      # we can use the identifier of the stone, as it should not be taken
      # (it may have been taken before, but for that stone to be played the
      # other group would have had to be captured before)
      @groups[identifier] = bare_group(identifier)
      @stone_to_group[identifier] = identifier
    end

    def bare_group(identifier)
      {
        id: identifier,
        stones: [identifier],
        liberty_count: 0,
        liberties: {}
      }
    end

    def shared_liberty?(my_color, other_color)
      my_color == Board::EMPTY || other_color == Board::EMPTY
    end

    def color_to_neighbour(board, identifier)
      neighbors = board.neighbours_of(identifier)
      hash = neighbors.inject({}) do |hash, (identifier, color)|
        (hash[color] ||= []) << identifier
        hash
      end
      hash.default = []
      hash
    end

    def take_liberties_of_enemies(enemy_neighbours, identifier, board, capturer_color)
      enemy_neighbours.each do |enemy_identifier|
        enemy_group = group_of(enemy_identifier)
        remove_liberty(enemy_group, identifier)
        my_group = group_of(identifier)
        my_group[:liberties][enemy_identifier] = enemy_group[:id]
        remove(enemy_group, board, capturer_color) if caught?(enemy_group)
      end
    end

    def add_liberties(liberties, identifier)
      liberties.each do |liberty_identifier|
        add_liberty(group_of(identifier), liberty_identifier)
      end
    end

    def join_group_of_friendly_stones(friendly_stones, identifier)
      friendly_stones.each do |f_identifier, _color|
        connect group_id_of(f_identifier), identifier
      end
    end

  end
end