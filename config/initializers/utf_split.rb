# http://talklikeaduck.denhaven2.com/2009/05/28/safely-dividing-a-utf-8-string-in-ruby

class String
  def valid_utf8?
    unpack("U") rescue nil
  end

  def utf8_safe_split(n)
    if length <= n
      [self, nil]
    else
      before = self[0, n]
      after = self[n..-1]
      until after.valid_utf8?
        n = n - 1
        before = self[0, n]
        after = self[n..-1]
      end      
      [before, after.empty? ? nil : after]
    end
  end  

  def utf_snippet(len = 20)
    if len < self.length
      "#{self.utf8_safe_split(len).first}..."
    else
      self
    end
  end
end
