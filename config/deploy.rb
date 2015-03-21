lock '3.2.1'

set :application, 'AngularCycleGallery'

set :deploy_to, "/var/www/angular-cycle-gallery"

set :scm, :git
set :repo_url, 'git@github.com:Rademade/angular-cycle-gallery.git'

set :rvm_type, :system
set :rvm_ruby_version, 'ruby-2.1.5@angular-cycle-gallery'

set :linked_dirs, %w{bower_components node_modules}
set :keep_releases, 2

set :hipchat_token,         ENV['HIPCHAT_AUTH_TOKEN']
set :hipchat_room_name,     '379396'
set :hipchat_announce,      false
set :hipchat_color,         'yellow'
set :hipchat_success_color, 'green'

namespace :deploy do

  task 'npm:install' do
    on roles(:web) do
      within release_path do
        execute :npm, :install
      end
    end
  end

  task 'bower:install' do
    on roles(:web) do
      within release_path do
        execute :bower, :install
      end
    end
  end

  task 'gulp:install' do
    on roles(:web) do
      within release_path do
        execute "cd #{current_path} && node_modules/.bin/gulp build:development"
      end
    end
  end

  task 'app:restart' do
    on roles(:web) do
      within current_path do
        execute "kill $(ps aux | grep 'angular-cycle-gallery.*server.js' | awk '{print $2}')"
        execute "cd #{current_path} && node_modules/.bin/forever start server.js #{PORT} >> /dev/null 2>&1"
      end
    end
  end

  after :updated,   'deploy:npm:install'
  after :finishing, 'deploy:bower:install'
  after :finishing, 'deploy:gulp:install'
  after :finishing, 'deploy:app:restart'
  after :finishing, 'deploy:cleanup'

end
