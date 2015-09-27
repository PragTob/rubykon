require_relative 'spec_helper'

module Rubykon
  describe Stone do
    let(:default_x) {5}
    let(:default_y) {13}
    let(:default_color) {:black}

    let(:stone) {Stone.new default_x, default_y, default_color}

    subject {stone}

    describe "initialization" do
      it {is_expected.not_to be_nil}

      it 'correctly sets x' do
        expect(stone.x).to eq(default_x)
      end

      it 'correctly sets y' do
        expect(stone.y).to eq(default_y)
      end

      it 'correctly sets the color' do
        expect(stone.color).to eq(default_color)
      end
    end

    describe "#join" do
      it "joins the given group" do
        group = GroupOverseer.new(stone)
        stone.join group
        expect(stone.group).to be group
      end
    end

    describe "empty?" do
      it "is true for the empty color" do
        expect(Stone.new 1, 1, Board::EMPTY).to be_empty
      end

      it "is false when there is another color" do
        expect(Stone.new 1, 1, :black).not_to be_empty
      end
    end

    describe "pass?" do
      it "is false for a normal move" do
        expect(StoneFactory.build).not_to be_pass
      end

      it "is true when the move represents a pass (no x/y)" do
        expect(StoneFactory.build x: nil, y: nil).to be_pass
      end
    end

    describe "#==" do
      it "is equal to itself" do
        expect(subject).to eq subject
      end

      it "is equal to a stone with the same values" do
        expect(subject).to eq Stone.new(default_x, default_y, default_color)
      end

      it "is not equal to something with a different x" do
        expect(subject).not_to eq Stone.new(default_x + 1, default_y, default_color)
      end

      it "is not equal to something with a different y" do
        expect(subject).not_to eq Stone.new(default_x, default_y + 1, default_color)
      end
    end

    describe "#identifier" do
      it "represents the position on the board" do
        expect(subject.identifier).to eq '5-13'
      end
    end

    describe "#enemy_color" do
      it "returns white if the stone is black" do
        expect(Stone.new(1, 1, :black).enemy_color).to eq :white
      end

      it "returns black if the stone is white" do
        expect(Stone.new(1, 1, :white).enemy_color).to eq :black
      end
    end

    describe '#remove' do
      it "removes any affiliation to a group" do
        group = GroupOverseer.new(stone)
        stone.remove
        expect(stone.group).to be_nil
      end
    end
  end
end