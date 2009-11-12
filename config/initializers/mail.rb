domain = (GlobalPreference.get(:domain) || "benyehuda.com") rescue "benyehuda.com"
ActionMailer::Base.smtp_settings = {
  :address => "localhost",
  :port => 25,
  :domain => domain,
}
