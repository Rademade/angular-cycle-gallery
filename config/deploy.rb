lock '3.2.1'

set :application, 'AngularCycleGallery'

set :scm, :git

set :linked_dirs, %w{bower_components node_modules}
set :keep_releases, 2

namespace :deploy do

  task 'npm:install' do
    on roles(:web) do
      within release_path do
        execute :npm, :install, '--silent'
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

  after :updated,   'deploy:npm:install'
  after :finishing, 'deploy:bower:install'
  after :finishing, 'deploy:gulp:install'
  after :finishing, 'deploy:cleanup'

end
