require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  describe "route recognition" do

    it "should generate params { :controller => 'users', action => 'index' } from GET /users" do
      {:get => "/users"}.should route_to(:controller => "users", :action => "index")
    end

    it "should generate params { :controller => 'users', action => 'new' } from GET /users/new" do
      {:get => "/users/new"}.should route_to(:controller => "users", :action => "new")
    end

    it "should generate params { :controller => 'users', action => 'create' } from POST /users" do
      {:post => "/users"}.should route_to(:controller => "users", :action => "create")
    end

    it "should generate params { :controller => 'users', action => 'show', id => '1' } from GET /users/1" do
      {:get => "/users/1"}.should route_to(:controller => "users", :action => "show", :id => "1")
    end

    it "should generate params { :controller => 'users', action => 'edit', id => '1' } from GET /users/1;edit" do
      {:get => "/users/1/edit"}.should route_to(:controller => "users", :action => "edit", :id => "1")
    end

    it "should generate params { :controller => 'users', action => 'update', id => '1' } from PUT /users/1" do
      {:put => "/users/1"}.should route_to(:controller => "users", :action => "update", :id => "1")
    end

    it "should generate params { :controller => 'users', action => 'destroy', id => '1' } from DELETE /users/1" do
      {:delete => "/users/1"}.should route_to(:controller => "users", :action => "destroy", :id => "1")
    end
  end
end
