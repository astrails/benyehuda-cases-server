domain = (GlobalPreference.get(:domain) || "benyehuda.com") rescue "benyehuda.com"
ActionMailer::Base.smtp_settings = {
  :address => "localhost",
  :port => 25,
  :domain => domain,
  :enable_starttls_auto => false  # XXX maybe to set through global preferences
}
