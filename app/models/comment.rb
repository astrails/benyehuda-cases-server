class Comment < ActiveRecord::Base
  belongs_to :task
  belongs_to :user
  
  validates_length_of :message, :in => 2..4096, :allow_nil => false, :allow_blank => false
  validates_presence_of :task_id, :user_id

  attr_accessible :message, :editor_eyes_only

  named_scope :public, :conditions => {:editor_eyes_only => false}
  named_scope :with_user, :include => :user

  after_create :notify_by_email

  def notify_by_email
    recipients = task.task_changes_recipients(true).select {|r| r.wants_to_be_notified_of?(:comments)}
    if editor_eyes_only?
      recipients = (recipients || []).select {|r| r.admin_or_editor?}
    end
    return if recipients.blank?

    if "production" == Rails.env
      send_later(:notify_comment_created, recipients)
    else
      notify_comment_created(recipients)
    end
  end

  def notify_comment_created(recipients)
    Notification.deliver_comment_added(self, recipients)
  end
end
