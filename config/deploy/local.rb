set :rvm_type, :user
set :rvm_ruby_version, 'ruby-2.1.5@angular-cycle-gallery'

set :repo_url, 'https://github.com/Rademade/angular-cycle-gallery.git'

set :deploy_to, "/home/vagrant/gallery"

server '127.0.0.1', user: 'vagrant', port: 2221, roles: %w{web app}
