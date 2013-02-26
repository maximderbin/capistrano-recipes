# :TODO: make mongodb tasks
namespace :deploy do
  task :migrate, :roles => :db  do
    logger.info "Skipping migration because mongoDB don't need it"
  end
  task :migrations, :roles => :db  do
    logger.info "Skipping migration because mongoDB don't need it"
  end
end
