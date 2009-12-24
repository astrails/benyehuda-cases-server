class Comment < ActiveRecord::Base
  belongs_to :task
  belongs_to :user
  
  validates_length_of :message, :in => 2..4096, :allow_nil => false, :allow_blank => false
  validates_presence_of :task, :user

  attr_accessible :message, :editor_eyes_only

  named_scope :public, :conditions => {:editor_eyes_only => false}
  named_scope :with_user, :include => :user
end
