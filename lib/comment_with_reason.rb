module CommentWithReason
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  def event_with_comment(event, task)
    send("#{event}_with_comment", task[:comment][:message], task[:request_new_task])
  end

  def commentable_event?(event)
    self.respond_to?("#{event}_with_comment")
  end

  module ClassMethods
    def event_completed_messages; @event_completed_messages; end
    attr_accessor :event_comple_messages

    def event_complete_message(event)
      @event_completed_messages[event.to_s]
    end

    def has_reason_comment(event, reason, actor, flash)
      comment_attribute = "#{reason}_comment"
      attr_accessor comment_attribute
      attr_accessible comment_attribute

      human_event_name = event.to_sym.task_event_cleanup
      @event_completed_messages ||= {}
      @event_completed_messages[human_event_name] = flash

      define_method "#{event.to_sym.task_event_cleanup}_with_comment" do |message, opts|
        comment = self.comments.build(:message => message)
        comment.user_id = send("#{actor}_id")
        comment.send("is_#{reason}_reason=", true)
        self.send("#{comment_attribute}=", comment)
        yield(self, opts) if block_given?
        self.send(event)
        comment.save
      end
    end
  end
end