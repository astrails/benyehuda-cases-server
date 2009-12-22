require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Comment do
  before(:each) do
    @comment = Comment.new
    @comment.should_not be_valid
  end

  describe "validations" do
    [:task, :user, :message].each do |a|
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
end
