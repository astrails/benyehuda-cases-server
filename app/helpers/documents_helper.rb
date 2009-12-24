module DocumentsHelper
  def document_can_be_deleted_by?(doc, user)
    user.is_admin? || doc.user_id == user.id
  end
end
