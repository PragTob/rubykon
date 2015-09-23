require_relative 'spec_helper'

module Rubykon
  describe Rubykon::MoveValidator do

    let(:validator) {Rubykon::MoveValidator.new}
    let(:board_size) {19}
    let(:game) {Rubykon::Game.new board_size}
    let(:baord) {game.board}

    it 'can be created' do
      expect(validator).not_to be_nil
    end

    describe 'legal moves' do
      it 'is accepts normal moves' do
        should_be_valid_move Rubykon::StoneFactory.build, game
      end

      it 'accepts 1-1' do
        should_be_valid_move (Rubykon::StoneFactory.build x: 1, y: 1), game
      end

      it 'accepts the move in the top right corner (19-19)' do
        should_be_valid_move Rubykon::StoneFactory.build(x: board_size,
                                                         y: board_size),
                              game
      end

      it 'accepts a different color' do
        should_be_valid_move (Rubykon::StoneFactory.build color: :white), game
      end

      it 'also works correctly with bigger boards' do
        game = Rubykon::Game.new 37
        should_be_valid_move (Rubykon::StoneFactory.build x: 37, y: 37), game
      end

      it "allows for pass moves" do
        should_be_valid_move StoneFactory.pass, game
      end
    end

    describe 'Moves illegal of their own' do
      it 'is illegal with negative x and y' do
        move = Rubykon::StoneFactory.build x: -3, y: -4
        should_be_invalid_move move, game
      end

      it 'is illegal with negative x' do
        move = Rubykon::StoneFactory.build x: -1
        should_be_invalid_move move, game
      end

      it 'is illegal with negative y' do
        move = Rubykon::StoneFactory.build y: -1
        should_be_invalid_move move, game
      end

      it 'is illegal with x set to 0' do
        move = Rubykon::StoneFactory.build x: 0
        should_be_invalid_move move, game
      end

      it 'is illegal with y set to 0' do
        move = Rubykon::StoneFactory.build y: 0
        should_be_invalid_move move, game
      end
    end

    describe 'Moves illegal in the context of a board' do
      it 'is illegal with x bigger than the board size' do
        move = Rubykon::StoneFactory.build x: board_size + 1
        should_be_invalid_move move, game
      end

      it 'is illegal with y bigger than the board size' do
        move = Rubykon::StoneFactory.build y: board_size + 1
        should_be_invalid_move move, game
      end

      it 'is illegal to set a stone at a position already occupied by a stone' do
        move = Rubykon::StoneFactory.build x: 1, y: 1
        game.play move
        should_be_invalid_move move, game
      end

      it 'also works for other board sizes' do
        game = Rubykon::Game.new 5
        should_be_invalid_move (Rubykon::StoneFactory.build x: 6), game
      end
    end

    describe 'suicide moves' do
      it "is forbidden" do
        game = Game.from <<-BOARD
-X-
X-X
-X-
        BOARD
        force_next_move_to_be :white, game
        should_be_invalid_move Stone.new(2, 2, :white), game
      end

      it "is forbidden in the corner as well" do
        game = Game.from <<-BOARD
-X-
X--
---
        BOARD
        force_next_move_to_be :white, game
        should_be_invalid_move Stone.new(1, 1, :white), game
      end

      it "is forbidden when it robs a friendly group of its last liberty" do
        game = Game.from <<-BOARD
OX--
OX--
OX--
-X--
        BOARD
        force_next_move_to_be :white, game
        should_be_invalid_move Stone.new(1, 4, :white), game
      end

      it "is valid if the group still has liberties with the move" do
        game = Game.from <<-BOARD
OX--
OX--
OX--
----
        BOARD
        force_next_move_to_be :white, game
        should_be_valid_move Stone.new(1, 4, :white), game
      end

      it "is valid if it captures the group" do
        game = Game.from <<-BOARD
OXO-
OXO-
OXO-
-XO-
        BOARD
        force_next_move_to_be :white, game
        should_be_valid_move Stone.new(1, 4, :white), game
      end

      it "is allowed when it captures a stone first (e.g. no suicide)" do
        game = Game.from <<-BOARD
----
-XO-
X-XO
-XO-
        BOARD
        force_next_move_to_be :white, game
        should_be_valid_move Stone.new(2, 3, :white), game
      end
    end

    describe 'KO' do

      let(:game) {setup_ko_board}
      let(:move_2_2) {Rubykon::StoneFactory.build x: 2, y: 2, color: :white}

      it 'is a valide move for white at 2-2' do
        force_next_move_to_be :white, game
        should_be_valid_move move_2_2, game
      end

      it 'is an invalid move to catch back for black after white played 2-2' do
        skip 'woops need to implement catching stones first'
        game.play move_2_2
        should_be_invalid_move Rubykon::StoneFactory.build(x: 2, y: 3, color: :black), game
      end

    end

    describe "double move" do
      it "is not valid for the same color to move two times" do
        move_1 = StoneFactory.build x: 2, y: 2, color: :black
        move_2 = StoneFactory.build x: 1, y: 1, color: :black
        expect(game.play move_1).to be_truthy
        should_be_invalid_move move_2, game
      end
    end

    def force_next_move_to_be(color, game)
      game.play StoneFactory.pass(Stone.other_color(color))
    end

    def should_be_invalid_move(move, game)
      move_validate_should_return(false, move, game)
    end

    def should_be_valid_move(move, game)
      move_validate_should_return(true, move, game)
    end

    def move_validate_should_return(bool, move, game)
      expect(validator.valid?(move, game)).to be bool
    end

    def setup_ko_board
      Game.from <<-BOARD
-XO-
X-XO
-XO-
----
      BOARD
    end
  end
end
