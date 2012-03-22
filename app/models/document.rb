class Document < ActiveRecord::Base
  belongs_to :user
  belongs_to :task , :touch => true, :counter_cache => true

  IMAGE_FILE_EXTS = ["jpg", "png", "tiff", "tif", "gif", "jpeg", "bmp"]

  include ActsAsAuditable
  acts_as_auditable :file_file_name,
    :name => :file_file_name,
    :auditable_title => proc {|d| s_("document audit|Document %{file_name}") % {:file_name => d.file_file_name}},
    :audit_source => proc {|d| s_("document audit| by %{user_name}") % {:user_name => d.user.try(:name)}},
    :default_title => N_("auditable|Document")
  

  has_attached_file :file,
    :storage        => :s3,
    :bucket         => GlobalPreference.get(:s3_bucket),
    :path =>        "documents/:id/:filename",
    :default_url   => "",
    :s3_credentials => {
      :access_key_id     => GlobalPreference.get(:s3_key),
      :secret_access_key => GlobalPreference.get(:s3_secret),
    },
    :url => ':s3_domain_url'
  attr_accessible :file
  validates_attachment_presence :file
  validates_attachment_size :file, :less_than => 10.megabytes

  validates :user_id, :task_id, :presence => true

  scope :uploaded_by, lambda {|user| where("documents.user_id = ?", user.id)}

  def mark_as_deleted!
    self.deleted_at = Time.now.utc
    save!
    Task.decrement_counter(:documents_count, self.task_id)
  end

  def image?
    !file_file_name.blank? && IMAGE_FILE_EXTS.member?((File.extname(file_file_name)[1..-1] || "").downcase)
  end
end
