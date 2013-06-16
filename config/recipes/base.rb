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

# List of common utils that should be installed.
set_default :general_packages, <<-EOS
  vim mc zsh curl git-core
EOS

# Will install common packages.
namespace :deploy do
  desc "Installs common packages"
  task :install do
    run "#{sudo} apt-get -y install python-software-properties"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install #{general_packages}"
  end
end
