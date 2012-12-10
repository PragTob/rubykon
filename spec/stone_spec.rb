require_relative 'spec_helper'

DEFAULT_X     = 5
DEFAULT_Y     = 13
DEFAULT_COLOR = :black

describe Rubykon::Stone do
  before :each do
    @stone = Stone.new DEFAULT_X, DEFAULT_Y, DEFAULT_COLOR
  end
  
  subject {@stone}
  it {should_not be_nil}
  
  it 'correctly sets x' do
    @stone.x.should == DEFAULT_X
  end
  
  it 'correctly sets y' do
    @stone.y.should == DEFAULT_Y
  end
  
  it 'correctly sets the color' do
    @stone.color.should == DEFAULT_COLOR
  end
  
  describe 'Playing it on a board' do
  
  end
  
end
