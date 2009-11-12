class VladifyGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.template "deploy.rb", "config/deploy.rb", :assigns => {
        :name => File.basename(File.expand_path(RAILS_ROOT))
      }
    end
  end
end

