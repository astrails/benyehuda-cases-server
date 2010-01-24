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

    it "should validate assignees" do
      task = @user.created_tasks.create!(:name => "some name", :kind => "typing", :difficulty => "normal", :full_nikkud => true)
      task.assignee.should be_nil
      task.editor.should be_nil

      task.should be_unassigned

      proc {task.assign!(nil, nil)}.should raise_error(ActiveRecord::RecordInvalid)
      task.reload.assignee.should be_nil
      task.editor.should be_nil
      task.should be_unassigned
      task.errors.on(:editor).should_not be_blank
      task.errors.on(:assignee).should_not be_blank
    end

    it "should cleanup assignee" do
      task = Factory.create(:assigned_task)
      task.abandon
      task.assignee_id.should be_blank
      task.should be_unassigned
    end

    it "should reject" do
      task = Factory.create(:waits_for_editor_approve_task)
      task.reject_with_comment("reason")
      task.should be_rejected
      task.rejection_comment.message.should == "reason"
      task.rejection_comment.is_rejection_reason.should be_true
      task.rejection_comment.user_id.should == task.editor_id
    end

    it "should abandon" do
      task = Factory.create(:assigned_task)
      a_id = task.assignee_id
      task.abandon_with_comment("reason")
      task.should be_unassigned
      task.abandoning_comment.message.should == "reason"
      task.abandoning_comment.is_abandoning_reason.should be_true
      task.abandoning_comment.user_id.should == a_id
      task.assignee_id.should be_nil
    end

    it "should build_chained_task" do
      task = Factory.create(:approved_task)
      chained_task = task.build_chained_task({:name => "foo bar"}, task.editor)
      chained_task.parent_id.should == task.id
      chained_task.name.should == "foo bar"
      chained_task.should_receive(:clone_parent_documents).and_return(true)
      chained_task.save.should be_true
    end
  end

  describe "participant" do
    before(:each) do
      @task = Factory.create(:task)
    end
    [:creator, :assignee, :editor].each do |u|
      it "#{u} should be a participant" do
        @task.participant?(@task.send(u)).should be_true
      end
    end

    [:user, :another_volunteer, :active_user].each do |u|
      it "#{u} should not be a participant" do
        user = Factory.create(u)
        @task.participant?(user).should_not be_true
      end
    end
  end

  describe "events availability" do
    [:admin, :another_volunteer].each do |u|
      describe "#{u}" do
        before(:each) do
          @task = Factory.create(:task)
          @user = Factory.create(u)
        end
        Task.aasm_events.collect(&:first).collect(&:task_event_cleanup).each do |e|
          it "#{e} should not be allowed for" do
            @task.allow_event_for?(e, @user).should be_false
          end
        end
        ["destroy", "update", "junk", "foobar"].each do |e|
          it "#{e} should not be allowed for #{u}" do
            @task.allow_event_for?(e, @user).should be_false
          end
        end
      end
    end

    describe "editor - participant" do
      before(:each) do
        @task = Factory.create(:task)
        @user = @task.editor
      end

      { "reject" => true,
        "abandon" => false,
        "complete" => true,
        "finish" => false,
        "help_required" => false,
        "create_other_task" => true,
        "finish_partially" => false,
        "approve" => true
      }.each do |key, value|
        it "should #{value ? "allow" : "disallow"} #{key}" do
          @task.allow_event_for?(key, @user).should == value
        end
      end
    end

    describe "creator - participant" do
      before(:each) do
        @task = Factory.create(:task)
        @user = @task.creator
      end

      { "reject" => false,
        "abandon" => false,
        "complete" => false,
        "finish" => false,
        "help_required" => false,
        "create_other_task" => false,
        "finish_partially" => false,
        "approve" => false
      }.each do |key, value|
        it "should #{value ? "allow" : "disallow"} #{key}" do
          @task.allow_event_for?(key, @user).should == value
        end
      end
    end

    describe "volunteer - participant" do
      before(:each) do
        @task = Factory.create(:task)
        @user = @task.assignee
      end

      { "reject" => false,
        "abandon" => true,
        "complete" => false,
        "finish" => true,
        "help_required" => true,
        "create_other_task" => false,
        "finish_partially" => true,
        "approve" => false
      }.each do |key, value|
        it "should #{value ? "allow" : "disallow"} #{key}" do
          @task.allow_event_for?(key, @user).should == value
        end
      end
    end

  end
end
