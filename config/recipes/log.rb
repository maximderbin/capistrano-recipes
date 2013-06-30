# Conventient tasks for remotely tail'ing log files.
namespace :log do
  desc "Stream (tail) the application log."
  task :app do
    stream "tail -f '#{shared_path}/log/#{rails_env}.log'"
  end

  desc "Stream (tail) the Unicorn log."
  task :unicorn do
    stream "tail -f '#{shared_path}/log/unicorn.log'"
  end
end
