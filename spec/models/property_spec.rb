require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Property do
  before(:each) do
    @valid_attributes = {
      :title => "Having Fun", :parent_type => "Editor", :property_type => "boolean"
    }
  end

  it "should create a new instance given valid attributes" do
    Property.create!(@valid_attributes)
  end

  describe "validations" do
    before :each do
      @property = Property.new
    end

    describe "presence" do
      [:title, :parent_type, :property_type].each do |p|
        it "should validate presence of #{p}" do
          @property.should_not be_valid
          @property.errors.on(p).should_not be_blank
        end        
      end
    end

    describe "inclusion" do
      [:parent_type, :property_type].each do |p|
        it "should not allow wrong inclusions" do
          @property.send("#{p}=", "junk")
          @property.should_not be_valid
          @property.errors.on(p).should =~ /is not included in the list/
        end
      end
    end
  end
end
