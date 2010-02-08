require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Comment do
  before(:each) do
    @comment = Comment.new
    @comment.should_not be_valid
  end

  describe "validations" do
    [:task_id, :user_id, :message].each do |a|
      it "should validate #{a}" do
        @comment.errors.on(a).should_not be_blank
      end
    end
  end

  describe "named scopes" do
    it "should have public" do
      Comment.public.proxy_options.should == {:conditions => {:editor_eyes_only => false}}
    end

    it "should have with_user" do
      Comment.with_user.proxy_options.should == {:include => :user}
    end
  end

  describe "notification for unassigned task" do
    it "should not send notifications" do
      @task = Factory.create(:unassigned_task)
      @comment = @task.comments.new(:message => "foo bar foo bar")
      @comment.user_id = @task.creator_id
      @task.stub!(:current_controller).and_return mock("current_controller")
      ActionMailer::Base.deliveries = []
      current_controller.stub!(:current_user).and_return(@task.creator)

      @comment.save!
      ActionMailer::Base.deliveries.should be_blank
    end
  end

  describe "notification" do
    before(:each) do
      @task = Factory.create(:task)
      @comment = @task.comments.new(:message => "foo bar foo bar")
      @task.stub!(:current_controller).and_return mock("current_controller")
      ActionMailer::Base.deliveries = []
    end

    def check_email(user)
      ActionMailer::Base.deliveries.last.to_addrs.size.should == 1
      ActionMailer::Base.deliveries.last.to_addrs.to_s.should == user.email_recipient
      ActionMailer::Base.deliveries.last.body.should =~ /foo bar foo bar/
    end

    it "should send email to volunteer when editor added a comment" do
      @comment.user_id = @task.editor_id
      current_controller.stub!(:current_user).and_return(@task.editor)
      @comment.save!
      check_email(@task.assignee)
    end

    it "should send email to editor when assignee added a comment" do
      @comment.user_id = @task.assignee_id
      current_controller.stub!(:current_user).and_return(@task.assignee)
      @comment.save!
      check_email(@task.editor)
    end

    it "should send to assignee and editor when admin added a comment" do
      @comment.user_id = @task.creator_id
      current_controller.stub!(:current_user).and_return(@task.creator)
      @comment.save!
      ActionMailer::Base.deliveries.last.to_addrs.size.should == 2
      ActionMailer::Base.deliveries.last.to_addrs.collect(&:to_s).should == [@task.editor.email_recipient, @task.assignee.email_recipient]
      ActionMailer::Base.deliveries.last.body.should =~ /foo bar foo bar/
    end

    it "should send to edior if admin added an editor eyes only comment" do
      @comment.user_id = @task.creator_id
      @comment.editor_eyes_only = true
      current_controller.stub!(:current_user).and_return(@task.creator)
      @comment.save!
      check_email(@task.editor)
    end

    it "should not send any comments if editor added a an editor eyes only comment" do
      @comment.user_id = @task.editor_id
      @comment.editor_eyes_only = true
      current_controller.stub!(:current_user).and_return(@task.editor)
      @comment.save!
      ActionMailer::Base.deliveries.should be_blank
    end
  end
end
