class SearchSetting < ActiveRecord::Base
  attr_accessible :all
  belongs_to :user

  def self.set_from_params!(params)
    delete_all
    Task::SEARCH_KEYS.each do |key|
      create(:search_key => key, :search_value => params[key]) unless params[key].blank?
    end
  end
end
