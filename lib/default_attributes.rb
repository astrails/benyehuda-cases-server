module DefaultAttributes
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def default_attribute(attribute_name, value)
      define_method "#{attribute_name}" do
        read_attribute(attribute_name) || value
      end
    end
  end
end