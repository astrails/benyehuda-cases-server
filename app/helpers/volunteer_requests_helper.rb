module VolunteerRequestsHelper
  def confirm_button(volunteer_request)
    link_to _("Confirm"), volunteer_request_path(volunteer_request), :method => :put, :confirm => "Are you sure?"
  end
end
