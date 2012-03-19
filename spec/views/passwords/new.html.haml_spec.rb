require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/passwords/new.html.haml" do
  setup :activate_authlogic
  before do
    @user = assigns[:user] = Factory.build(:user)
  end

  it "should render new form" do
    render

    rendered.should have_tag('form', :with => {:action => passwords_path, :method => 'post'}) do
    end
  end
end
