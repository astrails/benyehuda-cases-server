class RestartController < ApplicationController
  before_filter :require_admin

  def restart
    system("touch #{RAILS_ROOT}/tmp/restart.txt")
    redirect_to "/"
  end
end