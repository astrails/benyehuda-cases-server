class AssignmentHistoriesController < InheritedResources::Base
  belongs_to :user
  before_filter :require_user
  actions :index

protected
  def collection
    @collection ||= end_of_association_chain.reverse_order.with_task.all
  end
end
