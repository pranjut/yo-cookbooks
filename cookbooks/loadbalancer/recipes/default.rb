#
# Cookbook Name:: loadbalancer
# Recipe:: default
#

require_recipe "nginx::source"

env_name=node.chef_environment

databag = data_bag_item(env_name, "proversity")

remote_url =  databag['proversity']['jenkins_root_url']

install_dir = "#{node[:ui][:install_dir]}"

app_name= "#{node[:ui][:appname]}"

bash "remove_existing_garbage" do
  code <<-EOH
  sudo rm -rf /usr/src/ui
  sudo mkdir -p /usr/src/testDrive
  EOH
end

remote_file "#{install_dir}/#{app_name}.zip" do
  source "#{remote_url}/ui.zip"
  mode "0644"
  action :create
end


bash "uncompress-#{app_name}" do
  cwd "/#{install_dir}"
  code <<-EOH
  sudo rm -rf #{app_name}
	sudo mkdir #{app_name}
	sudo mv #{app_name}.zip #{app_name}/
	cd #{app_name}
	sudo unzip #{app_name}.zip
	sudo rm -rf #{app_name}.zip
  EOH
end



case "#{env_name}"
when "prod"
cookbook_file "#{node[:ui][:cert_install_dir]}/server.crt" do
  source "#{env_name}/server.crt"
  mode "0644"
end

cookbook_file "#{node[:ui][:key_install_dir]}/server.key" do
  source "#{env_name}/server.key"
  mode "0644"
end

  pool_members = search(:node, "role:application AND chef_environment:#{env_name}")
  template '/etc/nginx/sites-available/default' do
    source 'loadbalancer.conf.erb'
      variables({
        :upstream_servers => pool_members.uniq,
        :port => databag['proversity']['application_port'],
        :install_dir => "#{install_dir}",
        :appName => "#{app_name}",
        :envName => databag['proversity']['environment_prefix'],
        :certInstallDir => "#{node[:ui][:cert_install_dir]}",
        :keyInstallDir => "#{node[:ui][:key_install_dir]}"      
      })
      notifies :restart, resources(:service => "nginx")
   end
when "alpha","beta","testdrive","softlayer"
	remote_file "/usr/src/testDrive/index.html" do
	  source "#{remote_url}/index.html"
	  mode "0644"
	  action :create
	end

  template '/etc/nginx/sites-available/default' do
      source 'loadbalancer_local.conf.erb'
        variables({
          :port => databag['proversity']['application_port'],
          :install_dir => "#{install_dir}",
          :appName => "#{app_name}",
          :envName => databag['proversity']['environment_prefix']
        })
        notifies :restart, resources(:service => "nginx")
     end
end
