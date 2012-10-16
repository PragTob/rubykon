require_relative 'spec_helper'

describe Rubykon::Board do
  subject {Rubykon::Board.new}
  it {should_not be_nil}
  it {should be_empty}
end
