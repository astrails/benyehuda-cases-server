# monkey patching to transliterate hebrew names

module Paperclip
  # The Attachment class manages the files for a given attachment. It saves
  # when the model saves, deletes when the model is destroyed, and processes
  # the file upon assignment.
  class Attachment

    def assign uploaded_file
      ensure_required_accessors!

      if uploaded_file.is_a?(Paperclip::Attachment)
        uploaded_file = uploaded_file.to_file(:original)
        close_uploaded_file = uploaded_file.respond_to?(:close)
      end

      return nil unless valid_assignment?(uploaded_file)

      uploaded_file.binmode if uploaded_file.respond_to? :binmode
      self.clear

      return nil if uploaded_file.nil?

      @queued_for_write[:original]   = uploaded_file.to_tempfile
      instance_write(:file_name,       uploaded_file.original_filename.strip.he_transliterate.gsub(/[^A-Za-z\d\.\-_]+/, '_'))
      instance_write(:content_type,    uploaded_file.content_type.to_s.strip)
      instance_write(:file_size,       uploaded_file.size.to_i)
      instance_write(:updated_at,      Time.now)

      @dirty = true

      post_process if valid?

      # Reset the file size if the original file was reprocessed.
      instance_write(:file_size, @queued_for_write[:original].size.to_i)
    ensure
      uploaded_file.close if close_uploaded_file
      validate
    end
  end
end

class String
  HE_TRANS = "קראטוןםפשדגכעיחלךףזסבהנמצתץ".split(//)
  EN_TRANS = "QRAJWNMPSDGKEIXLKPZSBHNMZTZ".split(//)
  def he_transliterate
    debugger
    res = self.clone
    HE_TRANS.each_with_index do |l, i|
      res.gsub!(l, EN_TRANS[i])
    end
    res
  end
end
