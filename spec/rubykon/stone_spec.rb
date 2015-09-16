require_relative 'spec_helper'

describe Rubykon::Stone do
  let(:default_x) {5}
  let(:default_y) {13}
  let(:default_color) {:black}

  let(:stone) {Rubykon::Stone.new default_x, default_y, default_color}
  
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
  
  describe 'Playing it on a board' do
  
  end
  
end
