namespace :remote do
  namespace :sphinx do
    %w/start restart stop conf index/.each do |op|
      desc "#{op} sphinx"
      remote_task op.to_sym, :roles => :sphinx do
        run rake("us:#{op}")
      end
    end
    task :config => "remote:sphinx:conf"

    remote_task :rebuild, :roles => :sphinx do
      run rake("us:stop") rescue nil
      run rake("us:index")
      run rake("us:start")
    end
  end
end

namespace :deploy do
  # "prepare" since we migh need migrations
  task :prepare  => "remote:sphinx:config"
  #task :restart => "remote:sphinx:rebuild"
end