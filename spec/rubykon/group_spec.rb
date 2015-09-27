require_relative 'spec_helper'

module Rubykon
  RSpec.describe Group do

    let(:stone) {Stone.new 1, 1, :black}
    let(:other_stone) {Stone.new 1, 2, :black}
    let(:group) {Group.new stone}
    let(:other_group) {Group.new other_stone}

    describe 'initialization' do
      it 'starts with no liberties' do
        expect(group.liberty_count).to eq 0
        expect(group.liberties).to be_empty
      end

      it 'has the stone it was initialized with' do
        expect(group.stones).to contain_exactly stone
      end

      it 'also sets the group of the stone' do
        group
        expect(stone.group).to be group
      end
    end

    describe 'connect' do
      it "connects another stone without a group to the group" do
        group.connect(other_stone)
        expect(group.stones).to contain_exactly(stone, other_stone)
        expect(other_stone.group).to be group
      end

      it "connects another stone that already has a group to the group" do
        other_group
        group.connect(other_stone)
        expect(group.stones).to contain_exactly(stone, other_stone)
        expect(other_stone.group).to be group
      end

      describe 'connecting a group with multiple stones' do
        let(:new_stones) {[StoneFactory.build, StoneFactory.build]}
        let(:all_grouped_stones) {new_stones << other_stone << stone}

        before :each do
          new_stones.each {|stone| other_group.connect(stone)}
          group.connect(other_stone)
        end

        it "connects all stones of another group to the new group" do
          all_grouped_stones.each do |stone|
            expect(stone.group).to be group
          end
        end

        it "gives the group all the stones" do
          expect(group.stones).to match_array(all_grouped_stones)
        end
      end
    end

    describe 'liberties' do

      let(:liberty) {Stone.new 1, 2, Board::EMPTY}

      before :each do
        group.add_liberty liberty
      end

      describe '#add_liberty' do
        it "increases the liberty count" do
          expect(group.liberty_count).to eq 1
        end

        it "adds it to the liberties hash" do
          expect(group.liberties).to eq('1-2' => liberty)
        end

        it "is not caught" do
          expect(group).not_to be_caught
        end

        it 'is idempotent' do
          group.add_liberty liberty
          expect(group.liberty_count).to eq 1
          expect(group.liberties).to eq('1-2' => liberty)
        end
      end

      describe "#remove_liberty" do
        let(:liberty_taking_stone) {Stone.new 1, 2, :white}

        before :each do
          group.remove_liberty(liberty_taking_stone)
        end

        it "decreases the liberty count back to 0" do
          expect(group.liberty_count).to eq 0
        end

        it "adds the new stone in, in the liberties hash" do
          expect(group.liberties).to eq('1-2' => liberty_taking_stone)
        end

        it "is caught" do
          expect(group).to be_caught
        end

        it 'is idempotent' do
          group.remove_liberty liberty_taking_stone
          expect(group.liberty_count).to eq 0
          expect(group.liberties).to eq('1-2' => liberty_taking_stone)
        end
      end
    end

    describe '.assign (integration style)' do
      let(:game) {Game.from board_string}
      let(:board) {game.board}

      def liberties_at(*identifiers)
        identifiers.inject({}) do |hash, identifier|
          x, y = identifier.split('-').map &:to_i
          hash[identifier] = Stone.new(x, y, Board::EMPTY)
          hash
        end
      end

      describe 'group of a lonely stone' do
        let(:board_string) do
          <<-BOARD
---
-X-
---
          BOARD
        end
        let(:group) {board[2, 2].group}

        it "has 4 liberties" do
          expect(group.liberty_count).to eq 4
        end

        it "has the stone" do
          expect(group.stones).to contain_exactly(board[2, 2])
        end

        it "correctly references those liberties" do
          expect(group.liberties).to eq liberties_at '2-1', '1-2', '3-2', '2-3'
        end
      end

      describe 'group of a lonely stone on the edge' do
        let(:board_string) do
          <<-BOARD
-X-
---
---
          BOARD
        end
        let(:group) {board[2, 1].group}

        it "has 4 liberties" do
          expect(group.liberty_count).to eq 3
        end

        it "correctly references those liberties" do
          expect(group.liberties).to eq liberties_at '1-1', '2-2', '3-1'
        end
      end

      describe 'group of a lonely stone in the corner' do
        let(:board_string) do
          <<-BOARD
X--
---
---
          BOARD
        end
        let(:group) {board[1, 1].group}

        it "has 4 liberties" do
          expect(group.liberty_count).to eq 2
        end

        it "correctly references those liberties" do
          expect(group.liberties).to eq liberties_at '2-1', '1-2'
        end
      end

      describe 'group of two' do
        let(:board_string) do
          <<-BOARD
----
-XX-
----
----
          BOARD
        end
        let(:group) {board[2, 2].group}

        it "has 4 liberties" do
          expect(group.liberty_count).to eq 6
        end

        it "correctly references those liberties" do
          expect(group.liberties).to eq liberties_at '1-2', '2-1', '3-1',
                                                     '4-2', '2-3', '3-3'
        end
      end

      describe 'connecting through a connect move' do

        before :each do
          game.set_valid_move connector
        end

        let(:group) {board[connector.x, connector.y].group}

        describe 'merging two groups with multiple stones' do
          let(:board_string) do
            <<-BOARD
-----
-----
XX-XX
-----
-----
            BOARD
          end

          let(:connector) {Stone.new 3, 3, :black}
          let(:all_stones) do
            [board[1, 3], board[2, 3], board[3, 3], board[4, 3], board[5, 3]]
          end

          it "has 10 liberties" do
            expect(group.liberty_count).to eq 10
          end

          it "all stones belong to the same group" do
            all_stones.each do |stone|
              expect(stone.group).to eq group
            end
          end

          it "group knows all the stones" do
            expect(group.stones).to match_array all_stones
          end

          it "does not think that the connector is a liberty" do
            expect(group.liberties[connector.identifier]).to be_nil
          end
        end

        describe 'connecting groups with a shared liberty' do
          let(:board_string) do
            <<-BOARD
----
--X-
-X--
----
            BOARD
          end

          let(:connector) {Stone.new 3, 3, :black}

          it 'has 7 liberties' do
            expect(group.liberty_count).to eq 7
          end

          it "does not think that the connector is a liberty" do
            expect(group.liberties[connector.identifier]).to be_nil
          end
        end

        describe 'group with multiple shared liberties' do
          let(:board_string) do
            <<-BOARD
-----
XXXXX
-----
XXXXX
-----
            BOARD
          end
          let(:connector) {Stone.new 3, 3, :black}

          it "has 14 liberties" do
            expect(group.liberty_count).to eq 14
          end

          it "reports the right group for connected stones" do
            expect(board[1, 4].group).to eq group
          end
        end

        describe "joining stones of the same group" do
          let(:board_string) do
            <<-BOARD
-----
XXXXX
X----
XXXXX
-----
            BOARD
          end
          let(:connector) {Stone.new 5,3, :black}

          it "has the right liberty count of 13" do
            expect(group.liberty_count).to eq 13
          end
        end

      end

      describe "taking away liberties" do
        describe "simple taking away" do
          let(:board_string) do
            <<-BOARD
---
-X-
-O-
            BOARD
          end

          it "gives the black stone 3 liberties" do
            expect(board[2, 2].group.liberty_count).to eq 3
          end

          it "gives the white stone two liberties" do
            expect(board[2, 3].group.liberty_count).to eq 2
          end
        end

        describe "before capture" do
          let(:board_string) do
            <<-BOARD
---
OXO
-O-
            BOARD
          end

          let(:white_stones) {[board[1, 2], board[3, 2], board[2, 3]]}
          let(:white_stone_groups) {white_stones.map &:group}

          it "leaves the black stone just one liberty" do
            expect(board[2, 2].group.liberty_count).to eq 1
          end

          it "the white stones have all different groups" do
            expect(white_stone_groups.uniq.size).to eq 3
          end

          it "the white stones all have 2 liberties" do
            white_stone_groups.each do |group|
              expect(group.liberty_count).to eq 2
            end
          end
        end

        describe "the tricky shared liberty situation" do
          let(:board_string) do
            <<-BOARD
-----
XXXXX
-O---
XXXXX
-----
            BOARD
          end

          let(:connector) {Stone.new 3, 3, :black}
          before :each do
            game.set_valid_move connector
          end

          it "the white group has just one liberty" do
            expect(board[2, 3].group.liberty_count).to eq 1
          end

          it "the black group has 13 liberties" do
            expect(board[3, 3].group.liberty_count).to eq 13
          end
        end

        describe "taking a liberty from a shared liberty group" do
          let(:board_string) do
            <<-BOARD
-----
XXXXX
--X--
XXXXX
-----
            BOARD
          end

          let(:taker) {Stone.new 2, 3, :white}
          before :each do
            game.set_valid_move taker
          end

          it "the white group has just one liberty" do
            expect(board[2, 3].group.liberty_count).to eq 1
          end

          it "the black group has 13 liberties" do
            expect(board[3, 3].group.liberty_count).to eq 13
          end
        end
      end

      describe "huge integration examples as well as regressions" do
        describe "integration" do
          let(:board_string) do
            <<-BOARD
XOOOOOOOOX-------X-
--XXXXXXX--------OO
----------X-----OXX
--------OOOOO---OX-
-------XOX-XOX--OXX
--------OXXXOX--OX-
--------OOOOO---OXX
-----------------OO
-------------------
---X-----------O---
---------------XO--
---------------XO--
---------------O---
--X----------------
-X--------------O--
-OXX-----------X-O-
-OOOXXX--X---X--XO-
----OO-----------X-
-------------------
            BOARD
          end

          it_behaves_like "has liberties at position", 1, 1, 1
          it_behaves_like "has liberties at position", 2, 1, 1
          it_behaves_like "has liberties at position", 18, 1, 2
          it_behaves_like "has liberties at position", 10, 1, 2
          it_behaves_like "has liberties at position", 3, 2, 9
          it_behaves_like "has liberties at position", 19, 2, 2
          it_behaves_like "has liberties at position", 11, 3, 3
          it_behaves_like "has liberties at position", 19, 3, 2
          it_behaves_like "has liberties at position", 9, 4, 15
          it_behaves_like "has liberties at position", 10, 5, 1
          it_behaves_like "has liberties at position", 14, 5, 4
          it_behaves_like "has liberties at position", 16, 11, 2
          it_behaves_like "has liberties at position", 17, 11, 4
          it_behaves_like "has liberties at position", 3, 14, 4
          it_behaves_like "has liberties at position", 2, 15, 3
          it_behaves_like "has liberties at position", 2, 16, 5
          it_behaves_like "has liberties at position", 3, 16, 3
          it_behaves_like "has liberties at position", 5, 17, 5
          it_behaves_like "has liberties at position", 17, 17, 3
          it_behaves_like "has liberties at position", 18, 17, 4
        end
      end
    end
  end
end