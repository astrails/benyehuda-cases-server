require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/passwords/edit.html.haml" do
  setup :activate_authlogic

  before do
    @user = assigns[:user] = Factory.create(:user)
    view.stub!(:logged_in?).and_return(true)
  end

  it "should render edit form" do
    render

    rendered.should have_tag('form', :with => {:action => password_path(@user.perishable_token), :method => 'post'}) do
    end
  end
end
