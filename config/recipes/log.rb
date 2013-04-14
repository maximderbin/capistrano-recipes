# Conventient tasks for remotely tail'ing log files.
namespace :log do
  desc "Stream (tail) the application's production log."
  task :production do
    stream "tail -f '#{shared_path}/log/production.log'"
  end

  desc "Stream (tail) the Unicorn log."
  task :unicorn do
    stream "tail -f '#{shared_path}/log/unicorn.log'"
  end
end
