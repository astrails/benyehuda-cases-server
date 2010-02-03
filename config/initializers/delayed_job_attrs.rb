module Delayed
  class Job < ActiveRecord::Base
    attr_accessible :all
  end
end