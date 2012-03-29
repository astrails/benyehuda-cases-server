class VolunteerKind < ActiveRecord::Base
  has_many :volunteers, :class_name => "User", :dependent => :destroy
  validates :name, :presence => true, :uniqueness => true
  before_destroy :volunteer_existance, :on => :destroy

  attr_accessible :name

  protected

  def volunteer_existance
    if volunteers.size > 0
      #FIXME: translate the string
      errors.add(:base, "There are existing volunteers of the #{name} kind. Please remove them first in order to delete this kind.")
      return false
    end
  end
end
