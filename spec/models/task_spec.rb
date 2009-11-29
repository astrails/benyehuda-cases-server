require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Task do
  before(:each) do
    @user = Factory.create(:admin)
  end

  describe "basic validations" do
    before(:each) do
      @task = @user.created_tasks.build
      @task.should_not be_valid
    end

    it "should validate name" do
      @task.errors.on(:name).should_not be_blank
    end
  end

  [:kind, :difficulty].each do |a|
    it "should have default values for #{a}" do
      Task.new.send(a).should_not be_blank
    end
  end

  it "should create new task with valid attributes" do
    @task = @user.created_tasks.create!(:name => "some name", :kind => "typing", :difficulty => "normal", :full_nikkud => true)
    @task.should be_unassigned
  end

  describe "extra events" do
    it "should assign editor and assignee" do
      task = @user.created_tasks.create!(:name => "some name", :kind => "typing", :difficulty => "normal", :full_nikkud => true)
      editor = Factory.create(:editor)
      volunteer = Factory.create(:volunteer)
      task.assign!(editor, volunteer)
      task.should be_assigned
      task.editor_id.should == editor.id
      task.assignee_id.should == volunteer.id
    end

    it "should cleanup assignee" do
      task = Factory.create(:assigned_task)
      task.abandon!
      task.assignee_id.should be_blank
      task.should be_unassigned
    end

    it "should reject" do
      task = Factory.create(:waits_for_editor_approve_task)
      task.should_receive :update_rejection
      task.reject!("reason")
      task.should be_rejected
      task.rejection_reason.should == "reason"
    end

    it "should have test for build_chained_task"
  end
end
