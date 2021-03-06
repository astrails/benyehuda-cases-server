module DashboardsHelper
  def waiting_for_task(volunteer)
    return time_ago_in_words(volunteer.task_requested_at) if volunteer.task_requested_at.present?
    return "N/A"
  end

  def pending_volunteer_requests
    pending_count = VolunteerRequest.pending.count
    if pending_count > 0
      haml_tag(:h5) do
        haml_concat link_to((n_('There is %d pending volunter request', 'There are %d pending volunter requests', pending_count) % pending_count), volunteer_requests_path)
      end
    end
  end
  
  def link_to_assign_a_task(user)
    link_to _("Assign a Task..."), tasks_path(:assignee_id => user.id, :per_page => 10), :method => :get,
      :onclick => "jQuery('#assign_now').html(#{_("Loading, please wait...").to_json}).dialog('open');", :remote => true
  end
end
