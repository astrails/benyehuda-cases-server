Dir[Rails.root.join('lib', '*.rb')].each do |f|
  require f
end
