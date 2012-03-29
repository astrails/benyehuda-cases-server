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

  has_gravatar
  has_attached_file :avatar, :styles => { :thumb => "50x50>", :medium => "100x100>" },
    :storage        => :s3,
    :bucket         => GlobalPreference.get(:s3_bucket),
    :path =>        "users/:id/avatars/:style/:filename",
    :s3_credentials => {
      :access_key_id     => GlobalPreference.get(:s3_key) || "junk",
      :secret_access_key => GlobalPreference.get(:s3_secret) || "junk",
    }
  attr_accessible :avatar
  def self.style_to_size(style)
    case style
    when :thumb
      50
    when :medium
      100
    else
      50
    end
  end

  has_many :assignment_histories, :dependent => :destroy

  validates :name, :presence => true

  scope :volunteers, where("is_volunteer = 1 AND activated_at IS NOT NULL AND disabled_at IS NULL")
  scope :all_volunteers, where("(users.is_volunteer = 1 OR is_editor = 1 OR is_admin = 1) AND activated_at IS NOT NULL AND disabled_at IS NULL")

  scope :editors, where("is_editor = 1 AND activated_at IS NOT NULL AND disabled_at IS NULL")
  scope :all_editors, where("(is_editor = 1 OR is_admin = 1) AND activated_at IS NOT NULL AND disabled_at IS NULL")

  scope :admins, where(:is_admin => true)

  scope :enabled, where("users.disabled_at IS NULL")
  scope :active, where("users.activated_at IS NOT NULL")
  scope :not_activated, where("users.activated_at is NULL")
  scope :active_first, order("users.current_login_at DESC")
  scope :by_id, order("users.id")
  scope :by_last_login, order("users.current_login_at DESC")

  #named_scope :waiting_for_tasks, {:conditions => "users.task_requested_at IS NOT NULL", :order => "users.task_requested_at DESC"}
  scope :waiting_for_tasks, order("users.task_requested_at DESC")

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
  has_many :search_settings

  after_update :check_volunter_approved

  define_index do
    indexes :name, :sortable => true
    indexes :email, :sortable => true
    has :disabled_at
    has :activated_at
    has :current_login_at
  end
  sphinx_scope(:sp_enabled) { {:where => "disabled_at is NULL"}}
  sphinx_scope(:sp_active_first) { {:order => "current_login_at DESC"}}
  sphinx_scope(:sp_all) { {}}

  def has_no_credentials?
    # self.crypted_password.blank?
    self.crypted_password.blank? && !activated_at.blank?
  end

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

  def allow_email_change?(force = false)
    force || activated_at.nil? || new_record?
  end

  def email_recipient
    addr = GlobalPreference.get(:email_override)
    addr = email if addr.blank?
    "#{name} <#{addr}>"
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

  def check_volunter_approved
    if is_volunteer_changed? && is_volunteer?
      Notification.volnteer_welcome(self).deliver
    end
  end

  def set_task_requested!
    self.task_requested_at = Time.now.utc
    save!
  end
end
