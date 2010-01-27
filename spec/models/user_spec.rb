require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  describe "named scopes" do
    {
      :admins => {:conditions => {:is_admin => true}},
      :all_editors => {:conditions => "(is_editor = 1 OR is_admin = 1) AND activated_at IS NOT NULL AND disabled_at IS NULL"},
      :editors => {:conditions => "is_editor = 1 AND activated_at IS NOT NULL AND disabled_at IS NULL"},
      :all_volunteers =>  {:conditions => "(users.is_volunteer = 1 OR is_editor = 1 OR is_admin = 1) AND activated_at IS NOT NULL AND disabled_at IS NULL"},
      :volunteers => {:conditions => "is_volunteer = 1 AND activated_at IS NOT NULL AND disabled_at IS NULL"}
    }.each do |scope_name, expectation|

      it "should generate for #{scope_name}" do
        User.send(scope_name).proxy_options.should == expectation
      end

      it "should respond to scope quering db" do
        User.send(scope_name).all
      end

    end
  end

  describe "protection" do
    [:is_admin, :is_volunteer, :is_editor].each do |role|
      it "should protect from assigning #{role}" do
        proc{User.new({role => true})}.should raise_error(ActiveRecord::UnavailableAttributeAssignmentError)
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
end