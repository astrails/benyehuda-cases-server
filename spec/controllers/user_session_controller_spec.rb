require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserSessionController do
  setup :activate_authlogic

  describe_action :new do
    it_should_render_template "new"
    it_should_assign :user_session
  end

  describe_action :destroy do
    it "should have test"
  end
end
