class Notification < ActionMailer::Base

  include TasksHelper
  helper :tasks

  def comment_added(comment, recipient_users)
    subject     s_("comment added notification subject|New comment (%{domain}): %{task_name_snippet}") % {
                  :task_name_snippet => comment.task.name.utf_snippet(20),
                  :domain => domain}
    from        from_address
    recipients  recipient_users.collect(&:to_email_address)
    sent_on     Time.now.utc
    body        :comment => comment, :task_url => task_url(comment.task)
  end

  def task_state_changed(task, recipient_users)
    subject     s_("state changed notification subject|%{state} (%{domain}): %{task_name_snippet}") % {
                  :state => textify_state(task.state), :task_name_snippet => task.name.utf_snippet(20),
                  :domain => domain}
    from        from_address
    recipients  recipient_users.collect(&:to_email_address)
    sent_on     Time.now.utc
    body        :task => task, :task_url => task_url(task)
  end

protected

  def domain
    if domain = GlobalPreference.get(:domain)
      default_url_options[:host] = domain
    end
    @domain ||= domain
  end

  def from_address
    GlobalPreference.get(:notifications_default_email) || "asaf.bartov@gmail.com"
  end
end
