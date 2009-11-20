require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VolunteerRequest do
  it "should create" do
    @volunteer_request = VolunteerRequest.new(:reason => "some reason")
    @volunteer_request.user_id = 2
    @volunteer_request.should be_valid
    @volunteer_request.save
    @volunteer_request.should_not be_new_record
  end

  describe "validations" do
    before(:each) do
      @volunteer_request = VolunteerRequest.new
    end

    it "user_id" do
      @volunteer_request.should_not be_valid
      @volunteer_request.errors.on(:user_id).should_not be_blank
    end

    describe "reason" do
      it "should be short" do
        @volunteer_request.reason = "foo"
        @volunteer_request.should_not be_valid
        @volunteer_request.errors.on(:reason).should =~ /short/
      end

      it "should be short when blank" do
        @volunteer_request.should_not be_valid
        @volunteer_request.errors.on(:reason).should =~ /short/
      end

      it "should be long" do
        @volunteer_request.reason = "f" * 4097
        @volunteer_request.should_not be_valid
        @volunteer_request.errors.on(:reason).should =~ /long/
      end
    end
  end
end
