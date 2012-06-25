Paperclip::Attachment.module_eval do
  alias_method :secret_hash, :hash
  remove_method :hash
end
