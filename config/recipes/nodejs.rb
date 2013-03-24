# Provides a JavaScript runtime. This is of course required to run Node.js apps.
# This can still be useful if you're not deploying Node.js apps. For example if you
# need to compile CoffeeScript to JavaScript, or you make use of Rails' asset pipeline
# then you can install Node.js rather than having to include TheRubyRacer or TheRubyRhino in to your Gemfile.

namespace :nodejs do
  after "deploy:install", "nodejs:install"
  desc "Install the latest relase of Node.js."
  task :install, roles: :app do
    run "#{sudo} add-apt-repository ppa:chris-lea/node.js"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install nodejs"
  end
end
