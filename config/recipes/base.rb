def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

namespace :deploy do
  desc "Install everything onto the server"
  task :install do
    logger.info "Install everything onto the server"
  end
end
after "deploy:install", "deploy:install_dependencies"
after "deploy:install", "deploy:install_ruby"
after "deploy:install", "deploy:install_apps"
after "deploy:install", "deploy:install_tools"

namespace :deploy do
  desc "Install tools and ruby dependencies"
  task :install_dependencies do
    run "#{sudo} apt-get update"
    run "#{sudo} apt-get -y install build-essential"
    run "#{sudo} apt-get -y install zlib1g-dev"
    run "#{sudo} apt-get -y install libssl-dev"
    run "#{sudo} apt-get -y install libreadline-dev"
    run "#{sudo} apt-get -y install libyaml-dev"
    run "#{sudo} apt-get -y install libcurl4-openssl-dev"
    run "#{sudo} apt-get -y install curl"
    run "#{sudo} apt-get -y install git-core"
    run "#{sudo} apt-get -y install python-software-properties"
  end
  desc "Download, compile and install ruby and bundler"
  task :install_ruby do
    run "wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p385.tar.gz"
    run "tar -xvzf ruby-1.9.3-p385.tar.gz"
    run "cd ruby-1.9.3-p385/ && ./configure && make && #{sudo} make install"
    run "echo 'gem: --no-ri --no-rdoc' >> ~/.gemrc"
    run "#{sudo} gem install bundler"
  end
  desc "Install apps enviroment dependencies"
  task :install_apps do
    run "#{sudo} apt-get -y install nodejs"
    run "#{sudo} apt-get -y install imagemagick"
    run "#{sudo} apt-get -y install mongodb"
  end
  desc "Install tools"
  task :install_tools do
    run "#{sudo} apt-get -y install vim"
    run "#{sudo} apt-get -y install mc"
    run "#{sudo} apt-get -y install zsh"
    run "curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh"
    run "curl -L https://github.com/babybeasimple/dotfiles/raw/master/tools/install.sh | sh"
  end
end
