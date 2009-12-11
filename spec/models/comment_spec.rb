require 'spec_helper'

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
end
