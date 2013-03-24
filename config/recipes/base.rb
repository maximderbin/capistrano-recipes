# Wrapper method for quickly loading, rendering ERB templates
# and uploading them to the server.
def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

# Wrapper method to set default values for recipes.
def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

# List of ruby dependencies that should be installed.
set_default :ruby_dependencies, <<-EOS
  build-essential zlib1g-dev libssl-dev libreadline-dev libyaml-dev \
  libcurl4-openssl-dev curl git-core
EOS

# List of common utils that should be installed.
set_default :general_packages, <<-EOS
  vim imagemagick mc zsh
EOS

# Will install essential / common packages.
namespace :deploy do
  desc <<-EOS
    * Updates package list
    * Enable PPA (Custom Repositories)
    * Installs common packages
    * Installs Ruby dependencies
  EOS
  task :install do
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install python-software-properties"
    run "#{sudo} apt-add-repository ppa:blueyed/ppa"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install #{general_packages} #{ruby_dependencies}"
  end
end

namespace :ruby do
  after "deploy:install", "ruby:install"
  desc "Download, compile and install ruby and bundler"
  task :install do
    run "wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p385.tar.gz"
    run "tar -xvzf ruby-1.9.3-p385.tar.gz"
    run "cd ruby-1.9.3-p385/ && ./configure && make && #{sudo} make install"
    run "echo 'gem: --no-ri --no-rdoc' >> ~/.gemrc"
    run "#{sudo} gem install bundler"
  end
end
