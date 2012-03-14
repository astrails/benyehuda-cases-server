class Audit < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  belongs_to :auditable, :polymorphic => true
  belongs_to :task
  belongs_to :user
  
  attr_accessible :hidden, :changed_attrs, :note, :action, :task_id, :user_id
  
  serialize :changed_attrs
  
  ACTIONS = { :add => 1, :remove => 2, :update => 3 }
  
  EXCLUDE_ATTRS = [:message, :file_file_name]

  def long_messages
    case action
    when 1 # create
      [s_("audit created|%{title} was created%{via_source}.") % {:title => title, :via_source => via_source}] + compose_messages
    when 2 # removed
      [s_("audit removed|%{title} was removed.") % {:title => title}] + compose_messages
    when 3 # update
      compose_messages
    end
  end

  def title
    @title ||= if auditable
      auditable.class.auditable_title.respond_to?(:call) ? auditable.class.auditable_title.call(auditable) : auditable.name
    else
      s_(auditable_type.constantize.send(:default_title))
    end
  end

  def via_source
    (auditable && auditable.class.try(:audit_source)) ? auditable.class.audit_source.call(auditable) : nil
  end

  def compose_messages
    res = []
    self[:changed_attrs].each do |attribute_name, change|
      res << change_message(attribute_name, change) unless EXCLUDE_ATTRS.member?(attribute_name)
    end
    res.compact
  end

  def humanize_attr_change(attribute_name, change)
    return change unless conversion(attribute_name)
    change.map {|c| conversion(attribute_name).call(c)}
  end

  def change_message(attribute_name, change)
    from, to = humanize_attr_change(attribute_name, change)
    return nil unless to
    human_attr = convert_attribute_name(attribute_name) || attribute_name.to_s.humanize
    if from.blank?
      s_("audit set|%{attr} set to %{to}") % {:attr => human_attr, :to => escape_blanks(to)}
    else
      s_("audit changed|%{attr} changed from %{from} to %{to}") % {:attr => human_attr, :to => escape_blanks(to), :from => escape_blanks(from)}
    end
  end

  def escape_blanks(v)
    v ? v : "<empty>"
  end
  
  def action_string
    ACTIONS.index(action).to_s
  end
  
private
  def convert_attribute_name(attr)
    au_class = auditable ? auditable.class : auditable_type.constantize
    
    return nil unless au_class.audit_conversions.respond_to?(:[]) && au_class.audit_conversions[:attributes]
    au_class.audit_conversions[:attributes].call(attr)
  end

  def conversion(attr)
    auditable.class.audit_conversions[attr.to_sym] if auditable && auditable.class.audit_conversions.respond_to?(:[])
  end
  memoize :conversion
end
