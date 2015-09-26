require_relative 'spec_helper'

module Rubykon
  RSpec.describe Rubykon::Game do
    let(:game) {described_class.new}

    context 'creation' do
      subject {game}
      it {is_expected.not_to be_nil}

      it 'has a default size of 19' do
        expect(game.board.size).to eq(19)
      end

      it 'has a move_count of 0' do
        expect(game.move_count).to eq 0
      end

      it 'has no moves playd' do
        expect(game).to be_no_moves_played
      end

      it 'can be created with another size' do
        size = 13
        expect(Rubykon::Game.new(size).board.size).to eq size
      end

      it 'can retrieve the board' do
        expect(game.board).not_to be_nil
      end
    end

    describe "next_turn_color" do
      it "is black for starters" do
        expect(game.next_turn_color).to eq Board::BLACK_COLOR
      end

      it "is white after a black move" do
        game.play! StoneFactory.build color: Board::BLACK_COLOR
        expect(game.next_turn_color).to eq Board::WHITE_COLOR
      end

      it "is black again after a white move" do
        game.play! StoneFactory.build color: Board::BLACK_COLOR
        game.play! StoneFactory.build x: 4, y: 5, color: Board::WHITE_COLOR
        expect(game.next_turn_color).to eq Board::BLACK_COLOR
      end
    end

    describe "#finished?" do
      it "an empty game is not over" do
        expect(game).not_to be_finished
      end

      it "a game with one pass is not over" do
        game.set_valid_move(StoneFactory.pass color: :black)
        expect(game).not_to be_finished
      end

      it "a game with two passes is over" do
        game.set_valid_move(StoneFactory.pass color: :black)
        game.set_valid_move(StoneFactory.pass color: :white)
        expect(game).to be_finished
      end
    end

    describe ".from" do
      let(:string) do
        <<-GAME
X---O
--X--
X----
-----
-X--O
        GAME
      end

      let(:new_game)  {Game.from string}
      let(:board)     {new_game.board}

      it "sets the right number of moves" do
        expect(new_game.move_count).to eq 6
      end

      it "also populates moves" do
        expect(new_game.moves).not_to be_empty
      end

      it "assigns the stones a group" do
        expect(board[1, 1].group).not_to be_nil
      end

      it "does not assign a group to the empty fields" do
        expect(board[2, 2].group).to be_nil
      end

      it "has stones in all the right places" do
        expect(board[1, 1]).to eq Stone.new 1, 1, :black
        expect(board[5, 1]).to eq Stone.new 5, 1, :white
        expect(board[3, 2]).to eq Stone.new 3, 2, :black
        expect(board[1, 3]).to eq Stone.new 1, 3, :black
        expect(board[2, 5]).to eq Stone.new 2, 5, :black
        expect(board[5, 5]).to eq Stone.new 5, 5, :white
        expect(board[2, 2]).to eq Stone.new 2, 2, Board::EMPTY_COLOR
        expect(board[1, 4]).to eq Stone.new 1, 4, Board::EMPTY_COLOR
      end
    end

    describe 'playing moves' do

      let(:game) {Game.from board_string}
      let(:board) {game.board}

      describe 'play!' do
        let(:game) {Game.new 5}

        it "plays moves" do
          game.play!(Stone.new 2, 2, :black)
        end

        it "raises if the move is invalid" do
          expect do
            game.play!(Stone.new 0, 0, :black)
          end.to raise_error(IllegalMoveException)
        end
      end

      describe 'capturing stones' do
        let(:captures) {capturer.captures}

        before :each do
          game.set_valid_move(capturer)
        end

        describe 'simple star capture' do
          let(:board_string) do
            <<-BOARD
---
XOX
-X-
            BOARD
          end
          let(:capturer) {Stone.new 2, 1, :black}

          it "removes the captured stone from the board" do
            expect(board[1,1]).to be_empty
          end

          it "the stone made one capture" do
            expect(captures.size).to eq 1
          end

          it "the capture is the stone" do
            expect(captures.first).to eq Stone.new(2, 2, :white)
          end

          it_behaves_like "has liberties at position", 2, 1, 3
          it_behaves_like "has liberties at position", 1, 2, 3
          it_behaves_like "has liberties at position", 2, 3, 3
          it_behaves_like "has liberties at position", 3, 2, 3
        end

        describe 'turtle capture' do
          let(:board_string) do
            <<-BOARD
-----
-OO--
OXX--
-OOO-
-----
            BOARD
          end
          let(:capturer) {Stone.new 4, 3, :white}

          it "removes the two stones from the board" do
            expect(board[2, 3]).to be_empty
            expect(board[3, 3]).to be_empty
          end

          it "has 2 captures" do
            expect(captures.size).to eq 2
          end

          it_behaves_like "has liberties at position", 1, 3, 3
          it_behaves_like "has liberties at position", 2, 2, 6
          it_behaves_like "has liberties at position", 4, 3, 9
        end

        describe 'capturing two distinct groups' do
          let(:board_string) do
            <<-BOARD
-----
OO-OO
XX-XX
OO-OO
-----
            BOARD
            let(:capturer) {Stone.new 3, 3, :white}

            it "makes 4 captures" do
              expect(captures.size).to eq 4
            end

            it "removes the captured stones" do
              [board[1, 3], board[2, 3], board[4, 3], board[5, 3]].each do |field|
                expect(field).to be_empty
              end
            end

            it_behaves_like "has liberties at position", 1, 2, 5
            it_behaves_like "has liberties at position", 3, 2, 5
            it_behaves_like "has liberties at position", 3, 3, 4
            it_behaves_like "has liberties at position", 1, 4, 5
            it_behaves_like "has liberties at position", 3, 4, 5

          end
        end
      end

      describe 'Playing moves on a board (old board move integration)' do
        let(:game) {Game.new board_size}
        let(:board) {game.board}
        let(:board_size) {19}
        let(:simple_x) {1}
        let(:simple_y) {1}
        let(:simple_color) {:black}

        describe 'A simple move' do
          let(:move) {Stone.new simple_x, simple_y, simple_color}

          before :each do
            game.play move
          end

          it 'lets the board retrieve the move at that position' do
            expect(board[simple_x, simple_y]).to eq move
          end

          it 'sets the move_count to 1' do
            expect(game.move_count).to eq 1
          end

          it 'should have played moves' do
            expect(game).not_to be_no_moves_played
          end

          it 'can retrieve the played move through moves' do
            expect(game.moves.first).to eq move
          end

          it 'returns a truthy value' do
            legal_move = Rubykon::StoneFactory.build x: simple_x + 2, color: :white
            expect(game.play(legal_move)).to eq(true)
          end

          it "can play a pass move" do
            pass = StoneFactory.pass(:white)
            game.play pass
            expect(game.moves.last).to eq pass
          end
        end

        describe 'A couple of moves' do
          let(:moves) do
            [ StoneFactory.build(x: 3, y: 7, color: :black),
              StoneFactory.build(x: 5, y: 7, color: :white),
              StoneFactory.build(x: 3, y: 10, color: :black)
            ]
          end

          before :each do
            moves.each {|move| game.play move}
          end

          it 'sets the move_count to the number of moves played' do
            expect(game.move_count).to eq moves.size
          end

          it 'remembers the moves in the correct order' do
            expect(game.moves).to eq moves
          end

        end

        describe 'Illegal moves' do
          it 'is illegal to play moves with a greater x than the board size' do
            illegal_move = StoneFactory.build x: board_size + 1
            expect(game.play(illegal_move)).to eq(false)
          end

          it 'is illegal to play moves with a greater y than the board size' do
            illegal_move = StoneFactory.build y: board_size + 1
            expect(game.play(illegal_move)).to eq(false)
          end
        end
      end
    end
  end
end