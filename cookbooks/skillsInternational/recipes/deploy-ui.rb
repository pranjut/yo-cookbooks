#
# Cookbook Name:: loadbalancer
# Recipe:: default
#

require_recipe "nginx::source"

env_name=node.chef_environment

databag = data_bag_item(env_name, "skills")

remote_url =  databag['skills']['artifacts_root_url']

install_dir = "#{node[:skills][:install_dir]}"

app_name= databag['skills']['skills_ui_appname']
  
static_app_name= databag['skills']['skills_ui_static_appname']
pool_members = search(:node, "role:skillsInternational AND chef_environment:#{env_name}")


remote_file "#{install_dir}/#{app_name}.zip" do
  source "#{remote_url}/#{app_name}.zip"
  mode "0644"
  action :create
end

bash "uncompress-#{app_name}" do
  cwd "/#{install_dir}"
  code <<-EOH
  sudo rm -rf #{app_name}
  sudo mkdir -p #{app_name}
  sudo mv #{app_name}.zip #{app_name}/
  cd #{app_name}
  sudo unzip #{app_name}.zip
  sudo rm -rf #{app_name}.zip
  EOH
end

template '/etc/nginx/sites-available/default' do
  source 'skills_lb.conf.erb'
  variables({
    :upstream_servers => pool_members.uniq,
    :port => databag['skills']['application_port'],
    :install_dir => "#{install_dir}",
    :appName => "#{app_name}",
    :staticAppName => "#{static_app_name}"
  })
  notifies :restart, resources(:service => "nginx")
end
