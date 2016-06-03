set :rvm_type, :system
set :rvm_ruby_version, 'ruby-2.3.0@angular-cycle-gallery'

set :repo_url, 'git@github.com:Rademade/angular-cycle-gallery.git'

set :deploy_to, "/home/angular-cycle-gallery/website-frontend"

server 'angular-cycle-gallery.rademade.com', user: 'angular-cycle-gallery', roles: %w{web app}
