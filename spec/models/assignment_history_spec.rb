require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AssignmentHistory do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :task_id => 2,
      :role => "some"
    }
  end

  it "should create a new instance given valid attributes" do
    AssignmentHistory.create!(@valid_attributes)
  end

  describe "validations" do
    before(:each) do
      @assignment_history = AssignmentHistory.new
      @assignment_history.should_not be_valid
    end

    [:task_id, :user_id, :role].each do |a|
      it "should validate #{a}" do
        @assignment_history.errors.on(a).should_not be_blank
      end
    end
  end

  describe "creating" do
    it "should create assignments history" do
      task = Factory.create(:task)
      assignment_histories = task.assignment_histories.all

      0.step(2).each do |i|
        assignment_histories[i].task_id.should == task.id
      end
      assignment_histories[0].user_id.should == task.assignee_id
      assignment_histories[1].user_id.should == task.editor_id
      assignment_histories[2].user_id.should == task.creator_id

      assignment_histories[0].role.should == "assignee"
      assignment_histories[1].role.should == "editor"
      assignment_histories[2].role.should == "creator"
    end
  end
end
