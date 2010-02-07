class UserSession < Authlogic::Session::Base
  remember_me_for 30.days
  remember_me true
end