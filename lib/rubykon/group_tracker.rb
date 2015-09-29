module Rubykon
  class GroupTracker

    attr_reader :groups, :stone_to_group, :prisoners, :ko

    NOT_SET = :not_set

    def initialize(groups = {}, stone_to_group = {}, prisoners = initial_prisoners, ko = nil )
      @groups         = groups # group_id to stones, liberty count, liberties
      @stone_to_group = stone_to_group # stone identifier to group identifier
      @prisoners = prisoners
      @ko       = ko
    end

    def assign(identifier, color, board)
      neighbours_by_color = color_to_neighbour(board, identifier)
      join_group_of_friendly_stones(neighbours_by_color[color], identifier)
      create_own_group(identifier) unless group_id_of(identifier)
      add_liberties(neighbours_by_color[Board::EMPTY], identifier)
      potential_eye = EyeDetector.new.candidate_eye_color(identifier, board)
      captures = take_liberties_of_enemies(neighbours_by_color[Game.other_color(color)], identifier, board, color)
      if captures.size == 1 && potential_eye
        @ko = captures[0]
      else
        @ko = nil
      end
    end

    def liberty_count_at(identifier)
      group_of(identifier)[:liberty_count]
    end

    def dup
      self.class.new(dup_groups, @stone_to_group.dup, @prisoners.dup, @ko)
    end

    def group_id_of(identifier)
      @stone_to_group[identifier]
    end

    def group_of(identifier)
      group(group_id_of(identifier))
    end

    def group(id)
      @groups.fetch(id) {p id; raise}
    end

    private
    def initial_prisoners
      {Board::BLACK => 0, Board::WHITE => 0}
    end

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
      return if already_counted_as_liberty?(group, identifier, identifier)
      group[:liberties][identifier] = identifier
      group[:liberty_count] -= 1
    end

    def caught?(enemy_group)
      enemy_group[:liberty_count] <= 0
    end

    def remove(captured_group, board, capturer_color)
      liberties           = captured_group[:liberties].values
      neighbouring_groups = liberties.map do |identifier|
        group_of(identifier)
      end.compact.uniq
      neighbouring_groups.each do |neighbor_group|
        gain_liberties_from_capture_of(neighbor_group, captured_group)
      end
      captured_stones = captured_group[:stones]
      @prisoners[capturer_color] += captured_stones.size
      captured_stones.each do |identifier|
        @stone_to_group.delete identifier
        board[identifier] = Board::EMPTY
      end
      @groups.delete(captured_group[:id])
      captured_stones
    end

    def gain_liberties_from_capture_of(my_group, captured_group)
      new_liberties = my_group[:liberties].select do |_identifier, stone_identifier|
        group_id_of(stone_identifier) == captured_group[:id]
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

    def already_counted_as_liberty?(group, identifier, value)
      group[:liberties].fetch(identifier, NOT_SET) == value
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
      group_1[:liberties].merge!(group_2[:liberties]) do |_key, my_identifier, other_identifier|
        if shared_liberty?(my_identifier, other_identifier)
          group_1[:liberty_count] -= 1
        end
        my_identifier
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

    def dup_groups
      @groups.inject({}) do |dupped, (key, group)|
        dupped[key] = copy_group(group)
        dupped
      end
    end

    def copy_group(group)
      dupped = group.dup
      dupped[:stones] = group[:stones].dup
      dupped[:liberties] = group[:liberties].dup
      dupped
    end

    def shared_liberty?(my_identifier, other_identifier)
      my_identifier == Board::EMPTY || other_identifier == Board::EMPTY
    end

    def color_to_neighbour(board, identifier)
      neighbors = board.neighbours_of(identifier)
      hash = neighbors.inject({}) do |hash, (n_identifier, color)|
        (hash[color] ||= []) << n_identifier
        hash
      end
      hash.default = []
      hash
    end

    def take_liberties_of_enemies(enemy_neighbours, identifier, board, capturer_color)
      caught = []
      my_group = group_of(identifier)
      enemy_neighbours.each do |enemy_identifier|
        enemy_group = group_of(enemy_identifier)
        remove_liberties(enemy_identifier, enemy_group, identifier, my_group)
        collect_captured_groups(caught, enemy_group)
      end
      remove_caught_groups(board, capturer_color, caught)
    end

    def remove_liberties(enemy_identifier, enemy_group, identifier, my_group)
      remove_liberty(enemy_group, identifier)
      # this needs to be the identifier and not the group, as groups
      # might get merged
      my_group[:liberties][enemy_identifier] = enemy_identifier
    end

    def collect_captured_groups(caught, enemy_group)
      if caught?(enemy_group) && !caught.include?(enemy_group)
        caught << enemy_group
      end
    end

    def remove_caught_groups(board, capturer_color, caught)
      caught.inject([]) do |captures, enemy_group|
        captures + remove(enemy_group, board, capturer_color)
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