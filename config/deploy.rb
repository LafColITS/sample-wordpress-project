# config valid only for current version of Capistrano
lock '3.4.1'

set :application, 'sample'
set :repo_url, 'git@github.com:LafColITS/sample-wordpress-project.git'

# Deploy user; customize for local deployments
set :user, ENV['USER'] || "deploy"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/sample'

# Default value for :scm is :git
set :scm, :git
set :git_strategy, Capistrano::Git::SubmoduleStrategy
set :git_keep_meta, true

# Composer
set :composer_install_flags, '--no-dev --no-interaction --quiet --optimize-autoloader'

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, ENV['LOG_LEVEL'] || "error"

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('public/wp-config.php', 'public/.htaccess')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('public/wp-content/uploads')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 3

# Avoid collisions in temporary directory
set :tmp_dir, "/tmp/#{fetch(:user)}"

namespace :deploy do

  # Make mu-plugins available to WordPress
  after :published, :symlink_muplugins do
    on roles(:web) do |host|
      execute "cd #{fetch(:deploy_to)}/current/public/wp-content/mu-plugins && ln -sf more-privacy-options/ds_wp3_private_blog.php ds_wp3_private_blog.php"
    end
  end

  after :published, :restart_apache do
    on roles(:web) do |host|
      execute "sudo /sbin/apachectl graceful"
    end
  end

end
