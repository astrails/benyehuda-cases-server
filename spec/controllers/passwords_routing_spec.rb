require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PasswordsController do
  describe "route recognition" do
    it "should generate params { :controller => 'passwords', action => 'index' } from GET /passwords" do
      {:get, "/passwords"}.should_not be_routable
    end

    it "should generate params { :controller => 'passwords', action => 'new' } from GET /passwords/new" do
      {:get, "/passwords/new"}.should route_to(:controller => "passwords", :action => "new")
    end

    it "should generate params { :controller => 'passwords', action => 'create' } from POST /passwords" do
      {:post, "/passwords"}.should route_to(:controller => "passwords", :action => "create")
    end

    it "should generate params { :controller => 'passwords', action => 'show', id => '1' } from GET /passwords/1" do
      {:get, "/passwords/1"}.should_not be_routable
    end

    it "should generate params { :controller => 'passwords', action => 'edit', id => '1' } from GET /passwords/1;edit" do
      {:get, "/passwords/1/edit"}.should route_to(:controller => "passwords", :action => "edit", :id => "1")
    end

    it "should generate params { :controller => 'passwords', action => 'update', id => '1' } from PUT /passwords/1" do
      {:put, "/passwords/1"}.should route_to(:controller => "passwords", :action => "update", :id => "1")
    end

    it "should generate params { :controller => 'passwords', action => 'destroy', id => '1' } from DELETE /passwords/1" do
      {:delete => "/passwords/1"}.should_not be_routable
    end
  end
end
