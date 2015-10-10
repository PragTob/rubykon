require_relative '../lib/rubykon'
require_relative 'support/playout_help'
require_relative 'support/benchmark-ips'

class Rubykon::GameState
  public :plausible_move?
  public :next_turn_color
end

class Rubykon::EyeDetector
  public :candidate_eye_color
  public :is_real_eye?
end

class Rubykon::MoveValidator
  public :no_suicide_move?
  public :no_ko_move?
end

Benchmark.ips do |benchmark|
  empty_game = Rubykon::GameState.new Rubykon::Game.new 19
  mid_game = empty_game.dup
  200.times do
    mid_game.set_move mid_game.generate_move
  end
  finished_game = playout_for(19).game_state

  benchmark.report 'finished?' do
    finished_game.finished?
  end

  benchmark.report 'empty game generate_move' do
    empty_game.generate_move
  end

  benchmark.report 'mid game (200 moves played) generate_move' do
    mid_game.generate_move
  end

  benchmark.report 'finished game generate_move (should pass)' do
    finished_game.generate_move
  end

  color = empty_game.next_turn_color

  benchmark.report 'empty board plausible_move?' do
    identifier = rand(361)
    empty_game.plausible_move?(identifier, color)
  end

  color = mid_game.next_turn_color

  benchmark.report 'mid board plausible_move?' do
    identifier = rand(361)
    mid_game.plausible_move?(identifier, color)
  end

  color = finished_game.next_turn_color
  benchmark.report 'finished board plausible_move?' do
    identifier = rand(361)
    finished_game.plausible_move?(identifier, color)
  end

  #
  # validator    = Rubykon::MoveValidator.new
  #
  # benchmark.report 'valid?' do
  #   validator.valid?(move, game)
  # end
  #
  # benchmark.report 'no_suicide_move?' do
  #   validator.no_suicide_move?(move, board)
  # end
  #
  # benchmark.report 'no_ko_move?' do
  #   validator.no_ko_move?(move, game)
  # end
  #
  # eye_detector = Rubykon::EyeDetector.new
  #
  # x = move.x
  # y = move.y
  #
  # benchmark.report 'is_eye?' do
  #   eye_detector.is_eye?(x, y, board)
  # end
  #
  # benchmark.report 'candidate_eye_color' do
  #   eye_detector.candidate_eye_color(x, y, board)
  # end
  #
  # candidate_eye_color = eye_detector.candidate_eye_color(x, y, board)
  #
  # benchmark.report 'is_real_eye?' do
  #   eye_detector.is_real_eye?(x, y, board, candidate_eye_color)
  # end
  #
  # benchmark.report 'diagonal_colors_of' do
  #   board.diagonal_colors_of(x, y)
  # end
  #
  # benchmark.report 'set_valid_move' do
  #   game.dup.set_valid_move move
  # end
  #
  # benchmark.report 'set' do
  #   board.set move
  # end
  #
  # stone = move
  #
  # benchmark.report 'assign' do
  #   Rubykon::Group.assign(stone, board.dup)
  # end
  #
  # benchmark.report 'color_to_neighbour' do
  #   Rubykon::Group.color_to_neighbour(board, stone)
  # end
  #
  # # benchmark.report 'create_own_group' do
  # #   Rubykon::Group.create_own_group(stone)
  # # end
  #
  #
  # # All of these methods mutate state of the groups and stones, that's why
  # # I made methods and moved them into the loop, as whatever they do when
  # # called with already mutated state again and again, isn't normal - might
  # # be enough for benchmarks and less interfering than creating all that
  # # test data - you can well move them outside again :)
  #
  # # note that I set the coordinates and color here to make sense, the code
  # # doesn't care about that though (that this data is right is made sure before)
  # # so these could be any stones
  #
  # # these are nonsense value though
  # empty_stone = Rubykon::Stone.new(8, 8, Rubykon::Board::EMPTY_COLOR)
  # enemy_stone = Rubykon::Stone.new(4, 3, :white)
  #
  #
  # def create_stone_1(empty_stone, enemy_stone)
  #   stone = Rubykon::Stone.new(2, 1, :black)
  #   liberties_1 = {
  #     '2-2' => empty_stone,
  #     '2-4' => enemy_stone,
  #     '3-5' => empty_stone,
  #     '4-6' => empty_stone,
  #     '7-6' => empty_stone
  #   }
  #   Rubykon::Group.new(stone, 4, liberties_1)
  #   stone
  # end
  #
  # def create_stone_2(empty_stone, enemy_stone)
  #   stone = Rubykon::Stone.new(2, 3, :black)
  #   liberties_2 = {
  #     '2-2' => empty_stone,
  #     '2-4' => enemy_stone,
  #     '6-5' => empty_stone,
  #     '3-6' => empty_stone,
  #     '7-6' => empty_stone
  #   }
  #   Rubykon::Group.new(stone, 4, liberties_2)
  #   stone
  # end
  #
  #
  # # "small groups" as they have few liberties and stones assigned to them,
  # # groups can easily have 20+ stones and even more liberties, but that'd
  # # be even more setup :)
  # benchmark.report 'connecting two small groups' do
  #   stones = [create_stone_1(empty_stone, enemy_stone),
  #             create_stone_2(empty_stone, enemy_stone)]
  #   my_stone = Rubykon::Stone.new(2, 2, :black)
  #   Rubykon::Group.join_group_of_friendly_stones(stones, my_stone)
  # end
  #
  # benchmark.report 'add_liberties' do
  #   liberties = [[2, 4], [2, 2], [2, 1], [1, 2]].map do |x, y|
  #     Rubykon::Stone.new(x, y, Rubykon::Board::EMPTY_COLOR)
  #   end
  #   Rubykon::Group.add_liberties(liberties, create_stone_1(empty_stone, enemy_stone))
  # end
  #
  #
  # # Does not trigger enemy_group.caught? and removing the group.
  # # That doesn't happen THAT often and it'd require to setup an according
  # # board (with each test run)
  # benchmark.report 'remove liberties of enemies' do
  #   enemy_stones = [Rubykon::Stone.new(2, 3, :white),
  #                   Rubykon::Stone.new(3, 5, :white)]
  #   liberties = {
  #     '2-1' => empty_stone,
  #     '2-4' => enemy_stone,
  #     '3-2' => empty_stone
  #   }
  #   Rubykon::Group.new(enemy_stones[0], 2, liberties)
  #   Rubykon::Group.new(enemy_stones[1], 2, liberties.dup)
  #   Rubykon::Group.take_liberties_of_enemies(enemy_stones,
  #                                create_stone_1(empty_stone, enemy_stone),
  #                                nil)
  # end
end
