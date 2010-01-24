class Symbol
  def task_event_cleanup
    self.to_s.gsub(/^_/, "")
  end
end

class Array
  def compact_blanks
    self.select {|v| !v.blank?}
  end
end
