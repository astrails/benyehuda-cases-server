module CommentsHelper
  def class_for_comment(comment)
    returning([]) do |res|
      res << "editor_eyes_only" if comment.editor_eyes_only?
      res << "rejection_reason" if comment.is_rejection_reason?
      res << "abandoning_reason" if comment.is_abandoning_reason?
    end.join(" ")
  end
end
