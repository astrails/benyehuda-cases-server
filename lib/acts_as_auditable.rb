module ActsAsAuditable
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def auditable_attrs; @auditable_attrs; end
    attr_accessor :auditable_name, :audit_conversions, :auditable_title, :audit_source
    
    def acts_as_auditable *attrs
      has_many :audits, :as => :auditable

      before_save :store_changed
      after_create :audit_creation
      after_update :audit_update
      before_destroy :audit_destroy
      
      options = attrs.last.is_a?(Hash) ? attrs.pop : {} 
      @auditable_name = options[:name] || :name
      @audit_conversions = options[:conversions] || {}
      @auditable_title = options[:auditable_title] || {}
      @audit_source = options[:audit_source] || nil
      @auditable_attrs = attrs
    end
  end

private
  attr_reader :changed_attrs
  def changed_attrs?
    !changed_attrs.blank?
  end
  
  def store_changed
    @changed_attrs = self.changes.symbolize_keys.slice(*(self.class.auditable_attrs.map {|a| a.is_a?(Hash) ? a[:attr] : a.to_sym}))
    self.class.auditable_attrs.select { |a| a.is_a?(Hash) }.each do |a|
      @changed_attrs[a[:attr]] = @changed_attrs[a[:attr]].map(&a[:map]) if @changed_attrs[a[:attr]]
    end
    @changed_attrs.reverse_merge!(self.class.auditable_name => [self.send(self.class.auditable_name)]) unless @changed_attrs.blank?
  end
  
  def audit_creation
    create_audit(:add)
  end
  
  def audit_update
    create_audit(:update) if changed_attrs?
  end
  
  def audit_destroy
    @changed_attrs ||= {} 
    @changed_attrs.reverse_merge!(self.class.auditable_name => [self.send(self.class.auditable_name)])
    create_audit(:remove)
  end
  
  def create_audit(action)
    audits.create(
      :action => Audit::ACTIONS[action],
      :changes => changed_attrs, 
      :hidden => self.respond_to?(:hidden) ? !!self.hidden : false,
      :user_id => guess_user_id, 
      :task_id => guess_task_id
    )
  end
  
  def guess_task_id
    if self.is_a?(Task)
      self.id
    elsif self.respond_to?(:task_id)
      self.task_id
    else
      nil
    end
  end
  
  def guess_user_id
    if self.is_a?(User)
      self.id
    else
      current_controller && current_controller.current_user && current_controller.current_user.id
    end
  end
end
