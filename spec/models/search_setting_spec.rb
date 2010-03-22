require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SearchSetting do
  before(:each) do
    @valid_attributes = {
      :search_key => "123",
      :search_value => "foobar"
    }
  end

  it "should create a new instance given valid attributes" do
    SearchSetting.create!(@valid_attributes)
  end
end
