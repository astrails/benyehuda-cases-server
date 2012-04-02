require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  describe "scopes" do
    {
      :admins => "`users`.`is_admin` = 1",
      :all_editors => "(is_editor = 1 OR is_admin = 1) AND activated_at IS NOT NULL AND disabled_at IS NULL",
      :editors => "is_editor = 1 AND activated_at IS NOT NULL AND disabled_at IS NULL",
      :all_volunteers => "(users.is_volunteer = 1 OR is_editor = 1 OR is_admin = 1) AND activated_at IS NOT NULL AND disabled_at IS NULL",
      :volunteers => "is_volunteer = 1 AND activated_at IS NOT NULL AND disabled_at IS NULL"
    }.each do |scope_name, expectation|

      it "should generate for #{scope_name}" do
        if scope_name == :admins
          User.send(scope_name).to_sql.should match /#{expectation}/
        else
          User.send(scope_name).where_values[0].should == expectation
        end
      end

      it "should respond to scope quering db" do
        User.send(scope_name).all
      end

    end
  end

  describe "protection" do
    user = Factory.build(:user, :email => "user1@example.com")
    [:is_admin, :is_volunteer, :is_editor].each do |role|
      it "should protect from assigning #{role}" do
        user.update_attributes(role => true)
        user.save!
        user.send(role).should be_false
      end
    end
  end

  it "should have custom properties" do
    user = Factory.create(:user)
    p = Property.create(:title => "some", :parent_type => "User", :property_type => "string")
    
    CustomProperty.count.should == 0
    user.user_properties = {p.id => {:custom_value => "some some"}}
    user.save
    CustomProperty.count.should == 1

    cp = user.reload.user_properties.first
    cp.custom_value.should == "some some"
  end

  describe :check_volunter_approved do
    it "should send a welcome email if user has changed to volunteer" do
      user = Factory.create(:active_user)
      user.is_volunteer = true
      user.save!
      ActionMailer::Base.deliveries.last.subject.should == "Welcome to Ben Yehuda Project"
    end
  end

  describe :handle_volunteer_kind do
    it "should remove volunteer kind if user has ceased his voluntarism :)" do
      user = Factory.create(:volunteer, :volunteer_kind_id => Factory.create(:volunteer_kind).id)
      user.volunteer_kind_id.should_not be_nil
      user.is_volunteer = false
      user.save!
      user.reload.volunteer_kind_id.should be_nil
    end
  end
end