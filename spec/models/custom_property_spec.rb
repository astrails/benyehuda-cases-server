require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CustomProperty do
  before(:each) do
    @valid_attributes = {
    }
  end

  describe "validations" do
    before(:each) do
      @custom_property = CustomProperty.new
      @custom_property.should_not be_valid
    end
    [:property_id, :proprietary_id, :proprietary_type].each do |c|
      it "should validate #{c}" do
        @custom_property.errors.on(c).should_not be_blank
      end
    end
  end
end
