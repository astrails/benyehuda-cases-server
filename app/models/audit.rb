class Audit < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  belongs_to :auditable, :polymorphic => true
  belongs_to :task
  belongs_to :user
  
  attr_accessible :hidden, :changes, :note, :action, :task_id, :user_id
  
  serialize :changes
  
  ACTIONS = { :add => 1, :remove => 2, :update => 3 }
  
  EXCLUDE_ATTRS = [:message, :file_file_name]

  def long_messages
    case action
    when 1 # create
      ["#{title} was created#{via_source}."] + compose_messages
    when 2 # removed
      ["#{title} was removed."] + compose_messages
    when 3 # update
      compose_messages
    end
  end

  def title
    @title ||= if auditable
      auditable.class.auditable_title.respond_to?(:call) ? auditable.class.auditable_title.call(auditable) : auditable.name
    else
      ""
    end
  end

  def via_source
    auditable.class.try(:audit_source) ? auditable.class.audit_source.call(auditable) : nil
  end

  def compose_messages
    res = []
    self[:changes].each do |attribute_name, change|
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
    human_attr = attribute_name.to_s.humanize
    if from.blank?
      "#{human_attr} set to #{escape_blanks(to)}."
    else
      "#{human_attr} changed from #{escape_blanks(from)} to #{escape_blanks(to)}."
    end
  end

  def escape_blanks(v)
    v ? v : "<empty>"
  end
  
  def action_string
    ACTIONS.index(action).to_s
  end
  
private
  def conversion(attr)
    auditable.class.audit_conversions[attr.to_sym] if auditable && auditable.class.audit_conversions.respond_to?(:[])
  end
  memoize :conversion
end
