require_relative 'spec_helper'

DEFAULT_X     = 5
DEFAULT_Y     = 13
DEFAULT_COLOR = :black

describe Rubykon::Move do
  before :each do
    @move = Rubykon::Move.new DEFAULT_X, DEFAULT_Y, DEFAULT_COLOR
  end
  
  subject {@move}
  it {should_not be_nil}
  
  it 'correctly sets x' do
    @move.x.should == DEFAULT_X
  end
  
  it 'correctly sets y' do
    @move.y.should == DEFAULT_Y
  end
  
  it 'correctly sets the color' do
    @move.color.should == DEFAULT_COLOR
  end  
  
end
