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

  named_scope :volunteers, {:conditions => {:is_volunteer => true}}
  named_scope :all_volunteers, {:conditions => "users.is_volunteer = 1 OR is_editor = 1 OR is_admin = 1"}

  named_scope :editors, {:conditions => {:is_editor => true}}
  named_scope :all_editors, {:conditions => "is_editor = 1 OR is_admin = 1"}

  named_scope :admins, {:conditions => {:is_admin => true}}

  named_scope :enabled, {:conditions => "users.disabled_at IS NULL"}

  has_one :volunteer_request
  has_many :confirmed_volunteer_requests, :class_name => "VolunteerRequest", :foreign_key => :approver_id
  # has_many :volunteers_approved, :through => :volunteer_confirmations, :source => :user

  include CustomProperties
  has_many_custom_properties :user # user_properties
  has_many_custom_properties :volunteer # volunteer_properties
  has_many_custom_properties :editor #editor_properties

  def disabled?
    !disabled_at.blank?
  end

  def might_become_volunteer?
    !is_volunteer? && !is_editor? && !is_admin? && volunteer_request.blank?
  end
end
