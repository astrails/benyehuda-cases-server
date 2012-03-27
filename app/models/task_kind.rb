class TaskKind < ActiveRecord::Base
  has_many :tasks, :dependent => :destroy
  validates :name, :presence => true
  before_destroy :validate_task_existance, :on => :destroy

  attr_accessible :name

  protected

  def validate_task_existance
    if tasks.size > 0
      errors.add(:base, "There are existing tasks that uses #{name} kind. Please remove them first in order to delete this kind.")
      return false
    end
  end
end
