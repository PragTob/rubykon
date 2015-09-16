require_relative 'spec_helper'

describe Rubykon::Stone do
  let(:default_x) {5}
  let(:default_y) {13}
  let(:default_color) {:black}

  let(:stone) {Rubykon::Stone.new default_x, default_y, default_color}
  
  subject {stone}
  it {should_not be_nil}
  
  it 'correctly sets x' do
    stone.x.should == default_x
  end
  
  it 'correctly sets y' do
    stone.y.should == default_y
  end
  
  it 'correctly sets the color' do
    stone.color.should == default_color
  end
  
  describe 'Playing it on a board' do
  
  end
  
end
