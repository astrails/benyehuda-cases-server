class Symbol
  def task_event_cleanup
    self.to_s.gsub(/^_/, "")
  end
end