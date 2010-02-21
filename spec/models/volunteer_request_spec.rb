require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VolunteerRequest do
  it "should create" do
    @volunteer_request = VolunteerRequest.new(:preferences => "some reason")
    @volunteer_request.user_id = 2
    @volunteer_request.should be_valid
    @volunteer_request.save
    @volunteer_request.should_not be_new_record
  end

  describe "approval" do
    before(:each) do
      @volunteer_request = Factory.create(:volunteer_request)
      @admin = Factory.create(:admin)
      @volunteer_request.approve!(@admin)
    end

    it "should set approved_at" do
      @volunteer_request.approved_at.should_not be_blank
    end

    it "should set appover" do
      @volunteer_request.approver_id.should == @admin.id
    end

    it "should send welcome email" do
      ActionMailer::Base.deliveries.last.to_addrs.to_s.should == @volunteer_request.user.email_recipient
      ActionMailer::Base.deliveries.last.body.should =~ /Welcome to Ben Yehuda Project/
    end
  end

  describe "validations" do
    before(:each) do
      @volunteer_request = VolunteerRequest.new
    end

    it "user_id" do
      @volunteer_request.should_not be_valid
      @volunteer_request.errors.on(:user_id).should_not be_blank
    end

    describe "preferences" do
      it "should be short" do
        @volunteer_request.preferences = "foo"
        @volunteer_request.should_not be_valid
        @volunteer_request.errors.on(:preferences).should =~ /short/
      end

      it "should be short when blank" do
        @volunteer_request.should_not be_valid
        @volunteer_request.errors.on(:preferences).should =~ /short/
      end

      it "should be long" do
        @volunteer_request.preferences = "f" * 4097
        @volunteer_request.should_not be_valid
        @volunteer_request.errors.on(:preferences).should =~ /long/
      end
    end
  end
end
