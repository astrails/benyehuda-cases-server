class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.merge_validates_format_of_email_field_options :live_validator =>
      /^[A-Z0-9_\.%\+\-]+@(?:[A-Z0-9\-]+\.)+(?:[A-Z]{2,4}|museum|travel)$/i
    c.validates_length_of_password_field_options =
      {:on => :update, :minimum => 4, :if => :has_no_credentials?}
    c.validates_length_of_password_confirmation_field_options =
      {:on => :update, :minimum => 4, :if => :has_no_credentials?}
    c.perishable_token_valid_for = 2.weeks
  end
  include Astrails::Auth::Model
  attr_accessible :name, :password, :password_confirmation
  validates_presence_of :name
end
