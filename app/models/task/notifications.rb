module Task::Notifications

  SKIP_STATES = [:unassigned, :ready_to_publish, :other_task_creat]

  def self.included(base)
    base.class_eval do
      after_save  :delayed_notify_state_changes
    end
  end

  def task_changes_recipients(force = false)
    state_changed_by = []
    state_changed_for = []

    if state_changed? || force
      state_changed_for = [editor, assignee]
      state_changed_by << current_controller.current_user if current_controller && current_controller.current_user
    elsif editor_id_changed? || assignee_id_changed?
      state_changed_for << editor if editor_id_changed?
      state_changed_for << assignee if assignee_id_changed?
      state_changed_by << current_controller.current_user if current_controller && current_controller.current_user
    else
      return nil
    end

    (state_changed_for.compact.uniq - state_changed_by)
  end

  def delayed_notify_state_changes
    if "production" == Rails.env
      send_later :notify_state_changes
    else
      notify_state_changes
    end
  end

  def notify_state_changes
    return if SKIP_STATES.member?(state.to_sym)

    recipients = (task_changes_recipients || []).select {|r| r.wants_to_be_notified_of?(:state)}
    return if recipients.blank?

    I18n.with_locale(I18n.locale) { Notification.deliver_task_state_changed(self, recipients) }
  end
end