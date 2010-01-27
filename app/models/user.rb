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
  attr_accessible :name, :password, :password_confirmation, :notify_on_comments, :notify_on_status

  validates_presence_of :name

  named_scope :volunteers, {:conditions => {:is_volunteer => true}}
  named_scope :all_volunteers, {:conditions => "users.is_volunteer = 1 OR is_editor = 1 OR is_admin = 1"}

  named_scope :editors, {:conditions => {:is_editor => true}}
  named_scope :all_editors, {:conditions => "is_editor = 1 OR is_admin = 1"}

  named_scope :admins, {:conditions => {:is_admin => true}}

  named_scope :enabled, {:conditions => "users.disabled_at IS NULL"}
  named_scope :not_activated, {:conditions => "users.activated_at is NULL"}

  has_one :volunteer_request
  has_many :confirmed_volunteer_requests, :class_name => "VolunteerRequest", :foreign_key => :approver_id
  # has_many :volunteers_approved, :through => :volunteer_confirmations, :source => :user

  include CustomProperties
  has_many_custom_properties :user # user_properties
  has_many_custom_properties :volunteer # volunteer_properties
  has_many_custom_properties :editor #editor_properties

  has_many :created_tasks, :class_name => "Task", :foreign_key => "creator_id"
  has_many :editing_tasks, :class_name => "Task", :foreign_key => "editor_id", :order => "tasks.updated_at"
  has_many :assigned_tasks, :class_name => "Task", :foreign_key => "assignee_id", :order => "tasks.updated_at"

  has_many :comments

  def wants_to_be_notified_of?(type)
    case type.to_sym
    when :comments
      notify_on_comments?
    when :state
      notify_on_status?
    else
      nil
    end
  end

  def email
    email = GlobalPreference.get(:email_override)
    unless email.blank?
      email
    else
      read_attribute(:email)
    end
  end

  def disabled?
    !disabled_at.blank?
  end

  def might_become_volunteer?
    !is_volunteer? && !admin_or_editor? && volunteer_request.blank?
  end

  def public_roles
    @public_roles ||= returning([]) do |res|
      res << "admin" if is_admin?
      res << "editor" if is_editor?
      res << "volunteer" if is_volunteer?
    end
  end

  def deliver_activation_instructions_with_db_update!
    update_attribute(:activation_email_sent_at, Time.now.utc)
    deliver_activation_instructions_without_db_update!
  end
  alias_method_chain :deliver_activation_instructions!, :db_update

  def admin_or_editor?
    try(:is_admin?) || try(:is_editor?)
  end

  def to_email_address
    "#{name} <#{email}>"
  end
end
