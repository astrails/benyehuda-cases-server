# GetText users Array#find_index in its .po update task
# but find_index is only available in 1.8.7 while we still need to support 1.8.6
unless [].respond_to?(:find_index)
  class Array
    def find_index(arg = nil)
      if block_given?
        each_with_index do |x, i|
          return i if yield(x)
        end
        nil
      else
        index(arg)
      end
    end
  end
end