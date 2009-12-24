module CommentWithReason
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def has_reason_comment(event, reason, actor)
      comment_attribute = "#{reason}_comment"
      attr_accessor comment_attribute
      attr_accessible comment_attribute
      define_method "#{event.to_sym.task_event_cleanup}_with_comment" do |message|
        comment = self.comments.build(:message => message)
        comment.user_id = send("#{actor}_id")
        comment.send("is_#{reason}_reason=", true)
        self.send("#{comment_attribute}=", comment)
        yield(self) if block_given?
        self.send(event)
        comment.save
      end
    end
  end
end