require_relative 'spec_helper'

module Rubykon
  describe Stone do
    let(:default_x) {5}
    let(:default_y) {13}
    let(:default_color) {:black}

    let(:stone) {Stone.new default_x, default_y, default_color}

    subject {stone}
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

    describe "==" do
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
  end
end