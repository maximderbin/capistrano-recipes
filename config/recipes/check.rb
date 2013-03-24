# Make sure local git is in sync with remote.
namespace :check do
  before "deploy",      "check:revision"
  before "deploy:cold", "check:revision"
  desc "Make sure local git is in sync with remote."
  task :revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/#{branch}`
      puts "WARNING: HEAD is not the same as origin/#{branch}"
      puts "Run `git push` to sync changes."
      exit
    end
  end
end
