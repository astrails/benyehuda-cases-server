require File.dirname(__FILE__) + '/../../spec_helper'

describe "/user_session/new.html.haml" do
  setup :activate_authlogic

  before do
    @user_session = assigns[:user_session] = UserSession.new
  end

  it "should render new form" do
    render

    rendered.should have_tag('form', :with => {:action => user_session_path, :method => 'post'}) do
    end
  end
end