class SiteNotice < ActiveRecord::Base
  attr_accessible :start_displaying_at, :end_displaying_at, :html

  validates :html, :presence => true

  scope :active, lambda {
    sql = <<-SQL
      (site_notices.start_displaying_at is NULL OR site_notices.start_displaying_at <= ?)
      AND
      (site_notices.end_displaying_at is NULL OR ? < site_notices.end_displaying_at)
    SQL
    where(sql, Time.now.utc, Time.now.utc)
  }
end
