namespace :remote do
  namespace :sphinx do
    %w/index start restart stop rebuild config/.each do |op|
      desc "#{op} sphinx"
      remote_task op.to_sym, :roles => :sphinx do
        run rake("ts:#{op}")
      end
    end
  end
end

namespace :deploy do
  # "prepare" since we migh need migrations
  task :prepare  => "remote:sphinx:config"
  task :restart => "remote:sphinx:rebuild"
end