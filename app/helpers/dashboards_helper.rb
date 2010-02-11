module DashboardsHelper
  def pending_volunteer_requests
    pending_count = VolunteerRequest.pending.count
    if pending_count > 0
      haml_tag(:h5) do
        haml_concat link_to((n_('There is %d pending volunter request', 'There are %d pending volunter requests', pending_count) % pending_count), volunteer_requests_path)
      end
    end
  end
end
