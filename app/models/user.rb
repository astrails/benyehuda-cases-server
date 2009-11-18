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
  attr_accessible :name, :password, :password_confirmation, 
    :user_properties

  validates_presence_of :name

  named_scope :volunteers, {:conditions => {:is_volunteer => true}}
  named_scope :all_volunteers, {:conditions => "users.is_volunteer = 1 OR is_editor = 1 OR is_admin = 1"}

  named_scope :editors, {:conditions => {:is_editor => true}}
  named_scope :all_editors, {:conditions => "is_editor = 1 OR is_admin = 1"}

  named_scope :admins, {:conditions => {:is_admin => true}}

  named_scope :enabled, {:conditions => "users.disabled_at IS NULL"}

  def disabled?
    !disabled_at.blank?
  end

  [:user, :volunteer, :editor].each do |role|
    has_many "#{role}_properties".to_sym, :class_name => "CustomProperty", :as => :proprietary, :include => :property, :conditions => "properties.parent_type = '#{role.to_s.capitalize}'" do
      def indexed_by_id
        @indexed_by_id ||= index_by(&:property_id)
      end
    end
    define_method "#{role}_properties=" do |opts|
      opts.each do |property_id, attrs|
        cp = self.send("#{role}_properties").find_by_property_id(property_id) || self.send("#{role}_properties").build(:property_id => property_id)
        cp.attributes = attrs
      end
    end
    define_method "save_#{role}_properties" do
      self.send("#{role}_properties").each do |rp|
        rp.save if rp.changed?
      end
    end
    after_save "save_#{role}_properties".to_sym
  end
end
