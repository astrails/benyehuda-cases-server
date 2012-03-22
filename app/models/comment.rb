class Comment < ActiveRecord::Base
  belongs_to :task
  belongs_to :user
  
  include ActsAsAuditable
  acts_as_auditable :message, 
    :name => :message, 
    :auditable_title => proc {|c| s_("comment audit|Comment %{message}") % {:message => c.message}},
    :audit_source => proc {|c| s_("comment audit| by %{user_name}") % {:user_name => c.user.try(:name)}},
    :default_title => N_("auditable|Comment")

  validates :message, :length => {:in => 2..4096}, :allow_nil => false, :allow_blank => false
  # was: validates_presence_of :task, but - http://agaskar.com/post/396150446/has-many-through-accepts-nested-attributes-for-and
  # indeed hard to google for
  validates :user_id, :presence => true

  attr_accessible :message, :editor_eyes_only

  scope :public, where(:editor_eyes_only => false)
  scope :with_user, includes(:user)

  after_create :notify_by_email

  def notify_by_email
    recipients = task.task_changes_recipients(true).select {|r| r.wants_to_be_notified_of?(:comments)}
    if editor_eyes_only?
      recipients = (recipients || []).select {|r| r.admin_or_editor?}
    end
    return if recipients.blank?

    if "production" == Rails.env
      send_later(:notify_comment_created, recipients, I18n.locale)
    else
      notify_comment_created(recipients, I18n.locale)
    end
  end

  def notify_comment_created(recipients, use_locale)
    I18n.with_locale(use_locale) { Notification.deliver_comment_added(self, recipients) }
  end
end
