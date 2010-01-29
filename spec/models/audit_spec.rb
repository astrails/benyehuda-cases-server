require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Audit do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Audit.create!(@valid_attributes)
  end
end
