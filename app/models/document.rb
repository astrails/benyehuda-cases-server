class Document < ActiveRecord::Base
  belongs_to :user
  belongs_to :task , :touch => true

  has_attached_file :file,
    :storage        => :s3,
    :bucket         => GlobalPreference.get(:s3_bucket),
    :path =>        "tasks/:task_id/documents/:id/:filename",
    :default_url   => "",
    :s3_credentials => {
      :access_key_id     => GlobalPreference.get(:s3_key),
      :secret_access_key => GlobalPreference.get(:s3_secret),
    }
  attr_accessible :file
  validates_attachment_presence :file
  validates_attachment_size :file, :less_than => 10.megabytes

  validates_presence_of :user_id, :task_id

  # named_scope :active, :conditions => {:deleted_at => nil}
end