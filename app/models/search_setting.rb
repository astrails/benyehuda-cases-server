class SearchSetting < ActiveRecord::Base
  belongs_to :user

  attr_accessible :search_key, :search_value

  def self.set_from_params!(params)
    delete_all
    Task::SEARCH_KEYS.each do |key|
      create(:search_key => key, :search_value => params[key]) unless params[key].blank?
    end
  end

  def self.retrieve
    all.inject(HashWithIndifferentAccess.new) do |h, k|
      h[k.search_key] = k.search_value
      h
    end
  end

  def self.clear!
    delete_all
  end
end
