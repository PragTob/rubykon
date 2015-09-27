require_relative 'spec_helper'

module Rubykon
  RSpec.describe GroupOverseer do

    let(:overseer) {described_class.new}
    let(:group) do
      {
        id: 0,
        stones: [0]
      }
    end
    let(:other_group) {GroupOverseer.new other_stone}

    describe '#assign (integration style)' do
      let(:game) {Game.from board_string}
      let(:board) {game.board}
      let(:group_overseer) {game.group_overseer}
      let(:group) {group_overseer.group_of(identifier)}
      let(:identifier) {board.identifier_for(*coords)}
      let(:other_group) do
        group_from(*other_coords)
      end
      let(:another_group) do
        group_from(*another_coords)
      end
      let(:coords) {[connector[0], connector[1]]}
      let(:color) {connector.last}

      def liberties_at(*identifiers)
        identifiers.inject({}) do |hash, string_notation|
          x, y = string_notation.split('-').map &:to_i
          identifier = board.identifier_for(x, y)
          hash[identifier] = Board::EMPTY
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

        let(:coords) {[2, 2]}

        it "has 4 liberties" do
          expect(group[:liberty_count]).to eq 4
        end

        it "has the stone" do
          expect(group[:stones]).to contain_exactly(identifier)
        end

        it "correctly references those liberties" do
          expect(group[:liberties]).to eq liberties_at '2-1', '1-2', '3-2', '2-3'
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
        let(:coords) {[2, 1]}

        it "has 4 liberties" do
          expect(group[:liberty_count]).to eq 3
        end

        it "correctly references those liberties" do
          expect(group[:liberties]).to eq liberties_at '1-1', '2-2', '3-1'
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

        let(:coords) {[1, 1]}


        it "has 4 liberties" do
          expect(group[:liberty_count]).to eq 2
        end

        it "correctly references those liberties" do
          expect(group[:liberties]).to eq liberties_at '2-1', '1-2'
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
        let(:coords) {[2, 2]}

        it "has 4 liberties" do
          expect(group[:liberty_count]).to eq 6
        end

        it "correctly references those liberties" do
          expect(group[:liberties]).to eq liberties_at '1-2', '2-1', '3-1',
                                                     '4-2', '2-3', '3-3'
        end
      end

      describe 'connecting through a connect move' do

        before :each do
          game.set_valid_move identifier, color
        end

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

          let(:connector) {[3, 3, :black]}
          let(:all_stone_coords) do
            [[1, 3], [2, 3], [3, 3], [4, 3], [5, 3]]
          end

          let(:all_stones) do
            all_stone_coords.map do |x, y|
              board.identifier_for(x, y)
            end
          end

          let(:all_stone_group_ids) do
            all_stones.map do |identifier|
              group_overseer.group_id_of(identifier)
            end
          end

          it "has 10 liberties" do
            expect(group[:liberty_count]).to eq 10
          end

          it "all stones belong to the same group" do
            all_stone_group_ids.each do |group_id|
              expect(group_id).to eq group[:id]
            end
          end

          it "group knows all the stones" do
            expect(group[:stones]).to match_array all_stones
          end

          it "does not think that the connector is a liberty" do
            expect(group[:liberties]).not_to have_key(identifier)
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

          let(:connector) {[3, 3, :black]}

          it 'has 7 liberties' do
            expect(group[:liberty_count]).to eq 7
          end

          it "does not think that the connector is a liberty" do
            expect(group[:liberties]).not_to have_key(identifier)
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
          let(:connector) {[3, 3, :black]}
          let(:other_coords) {[1, 4]}

          it "has 14 liberties" do
            expect(group[:liberty_count]).to eq 14
          end

          it "reports the right group for connected stones" do
            expect(other_group).to eq group
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
          let(:connector) {[5,3, :black]}

          it "has the right liberty count of 13" do
            expect(group[:liberty_count]).to eq 13
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
          let(:other_coords) {[2, 2]}
          let(:another_coords) {[2, 3]}

          it "gives the black stone 3 liberties" do
            expect(other_group[:liberty_count]).to eq 3
          end

          it "gives the white stone two liberties" do
            expect(another_group[:liberty_count]).to eq 2
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

          let(:white_stone_coords) {[[1, 2], [3, 2], [2, 3]]}
          let(:white_stone_groups) do
            white_stone_coords.map {|x, y| group_from(x, y)}
          end
          let(:other_coords) {[2, 2]}

          it "leaves the black stone just one liberty" do
            expect(other_group[:liberty_count]).to eq 1
          end

          it "the white stones have all different groups" do
            expect(white_stone_groups.uniq.size).to eq 3
          end

          it "the white stones all have 2 liberties" do
            white_stone_groups.each do |group|
              expect(group[:liberty_count]).to eq 2
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

          let(:connector) {[3, 3, :black]}
          let(:other_coords) {[2, 3]}
          let(:another_coords) {[3, 3]}

          before :each do
            game.set_valid_move identifier, color
          end

          it "the white group has just one liberty" do
            expect(other_group[:liberty_count]).to eq 1
          end

          it "the black group has 13 liberties" do
            expect(another_group[:liberty_count]).to eq 13
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

          let(:taker) {[2, 3, :white]}
          let(:taker_group) {group_from taker[0], taker[1]}
          let(:other_coords) {[3, 3]}
          before :each do
            game.set_valid_move board.identifier_for(taker[0], taker[1]), taker[2]
          end

          it "the white group has just one liberty" do
            expect(taker_group[:liberty_count]).to eq 1
          end

          it "the black group has 13 liberties" do
            expect(other_group[:liberty_count]).to eq 13
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