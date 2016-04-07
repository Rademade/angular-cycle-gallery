set :rvm_type, :system
set :rvm_ruby_version, 'ruby-2.1.5@angular-cycle-gallery'

set :repo_url, 'git@github.com:Rademade/angular-cycle-gallery.git'

set :deploy_to, "/var/www/angular-cycle-gallery"

server 'rademade.com', user: 'deploy', roles: %w{web app}
