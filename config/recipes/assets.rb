# rewrites default deploy:assets:precompile task
# compile assets only when it needed
# compile assets locally
# handly compile assets on remote server, if you need it
#
# TODO: * make code less stinky
#       * check local and remote branch and revision before deploy
#       * add force compile task
#       * add remote compile task
set_default :files_to_check, <<-FILES
  vendor/assets/ app/assets/ lib/assets/ Gemfile.lock
FILES

namespace :deploy do
  namespace :assets do
    task :precompile, roles: :web, except: { no_release: true } do
      begin
        from = source.next_revision(current_revision) # <-- Fail here at first-time deploy because of current/REVISION absence
      rescue
        err_no = true
      end
      if err_no || capture("cd #{latest_release} && #{source.local.log(from)} #{files_to_check} | wc -l").to_i > 0
        precompile_locally
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end

    desc "Precompile assets on local machine and upload them to the server."
    task :precompile_locally do
      run_locally "bundle exec rake assets:precompile"
      find_servers_for_task(current_task).each do |server|
        run_locally "rsync -vr --exclude='.DS_Store' public/assets #{user}@#{server.host}:#{shared_path}/"
      end
      run_locally "rake assets:clean"
    end
  end
end
