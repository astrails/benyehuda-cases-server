require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  describe "named scopes" do
    {
      :admins => {:conditions => {:is_admin => true}},
      :all_editors => {:conditions => "is_editor = 1 OR is_admin = 1"},
      :editors => {:conditions => {:is_editor => true}},
      :all_volunteers =>  {:conditions => "users.is_volunteer = 1 OR is_editor = 1 OR is_admin = 1"},
      :volunteers => {:conditions => {:is_volunteer => true}}
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
end