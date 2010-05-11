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


class String
  def to_bool
    self.downcase.eql?("true") || self.downcase.eql?("1")
  end
end

class TrueClass
  def to_bool
    true
  end

  def to_i
  	1
  end
end

class FalseClass
  def to_bool
    false
  end
  
  def to_i
  	0
  end
end

class NilClass
  def to_bool
    false    
  end
end

