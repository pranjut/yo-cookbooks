#
# Cookbook Name:: massmailer
# Recipe:: default
#
# Copyright 2013, Proversity
#
# All rights reserved
#

env_name=node.chef_environment

databag = data_bag_item(env_name, "massmailer")

jenkins_root_url=databag['massmailer']['ci_root_url']

install_dir="#{node[:massmailer][:install_dir]}"

http_port=databag['massmailer']['http_port']

bash "create-dir" do
  code <<-EOH
  sudo mkdir -p #{node[:massmailer][:conf_file]}
  EOH
end

remote_file "#{install_dir}/#{node[:massmailer][:appname]}.zip" do
  source "#{jenkins_root_url}massmailer.zip"
  mode "0644"
  action :create
end

bash "unzip-#{node[:massmailer][:appname]}" do
  cwd "/#{node[:massmailer][:install_dir]}"
  code <<-EOH
    sudo rm -rf #{install_dir}/#{node[:massmailer][:appname]}
    sudo unzip #{install_dir}/#{node[:massmailer][:appname]}.zip
    sudo mv #{node[:massmailer][:appname]}-* #{node[:massmailer][:appname]}  
    sudo chmod +x #{install_dir}/#{node[:massmailer][:appname]}/start
    sudo rm -rf #{install_dir}/#{node[:massmailer][:appname]}.zip
  EOH
end


remote_file "#{node[:massmailer][:conf_file]}/massmailer.conf.erb" do
  source "#{jenkins_root_url}massmailer.conf.erb"
  mode "0644"
  action :create
end

template "#{node[:massmailer][:conf_file]}/application_massmailer.conf" do
  source "#{node[:massmailer][:conf_file]}/massmailer.conf.erb"
  local true
  variables({
                :smtpHost => databag['massmailer']['smtp_host_name'],
                :smtpPort => databag['massmailer']['smtp_port'],
                :smtpUser => databag['massmailer']['smtp_user'],
                :smtpPassword => databag['massmailer']['smtp_password'],
                :smtpFromAddress => databag['massmailer']['smtp_from_address'],
                :smtpSsl => databag['massmailer']['smtp_ssl'],
		:smtpTls => databag['massmailer']['smtp_tls']
            })
  action :create
end


template "/etc/init.d/#{node[:massmailer][:appname]}" do
  source "initd.erb"
  owner "root"
  group "root"
  mode "0744"
  variables({
                :name => "#{node[:massmailer][:appname]}",
                :path => "#{node[:massmailer][:install_dir]}/massmailer",
                :pidFilePath => "#{node[:massmailer][:pid_file_path]}",
                :options => "-Dconfig.file=#{node[:massmailer][:conf_file]}/application_massmailer.conf -Dhttp.port=#{http_port} -Dpidfile.path=#{node[:massmailer][:pid_file_path]}  -Xms512M -Xmx1024M -Xss1M -XX:MaxPermSize=512M",
                :command => "start"
            })
end

service "#{node[:massmailer][:appname]}" do
  supports :stop => true, :start => true, :restart => true
  action [ :enable, :restart ]
end









