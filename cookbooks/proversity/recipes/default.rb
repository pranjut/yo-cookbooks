#
# Cookbook Name:: proversity
# Recipe:: default
#
# Copyright 2013, Proversity
#
# All rights reserved
#

env_name=node.chef_environment

databag = data_bag_item(env_name, "proversity")

jenkins_root_url=databag['proversity']['jenkins_root_url']

remote_url =  databag['proversity']['proversity_dist_remote_url']

install_dir="#{node[:proversity][:install_dir]}"


remote_file "#{install_dir}/#{node[:proversity][:appname]}.zip" do
  source "#{jenkins_root_url}#{remote_url}proversity.zip"
  mode "0644"
  action :create
end

bash "unzip-#{node[:proversity][:appname]}" do
  cwd "/#{node[:proversity][:install_dir]}"
  code <<-EOH
    sudo rm -rf #{install_dir}/#{node[:proversity][:appname]}
    sudo unzip #{install_dir}/#{node[:proversity][:appname]}.zip
    sudo mv #{node[:proversity][:appname]}-* #{node[:proversity][:appname]}  
    sudo chmod +x #{install_dir}/#{node[:proversity][:appname]}/start
    sudo rm -rf #{install_dir}/#{node[:proversity][:appname]}.zip
  EOH
end


cookbook_file "#{node[:proversity][:conf_file]}/proversity.der" do
  source "proversity.der"
  mode "0644"
end

template "/etc/init.d/#{node[:proversity][:appname]}" do
  source "initd.erb"
  owner "root"
  group "root"
  mode "0744"
  variables({
                :name => "#{node[:proversity][:appname]}",
                :path => "#{node[:proversity][:install_dir]}/proversity",
                :pidFilePath => "#{node[:proversity][:pid_file_path]}",
                :options => "-Dconfig.file=#{node[:proversity][:conf_file]}/application.conf -Dpidfile.path=#{node[:proversity][:pid_file_path]} -Dlogger.file=#{node[:proversity][:conf_file]}/logger.xml -Xms512M -Xmx1024M -Xss1M -XX:MaxPermSize=512M",
                :command => "start"
            })
end

service "#{node[:proversity][:appname]}" do
  supports :stop => true, :start => true, :restart => true
  action [ :enable, :restart ]
end









