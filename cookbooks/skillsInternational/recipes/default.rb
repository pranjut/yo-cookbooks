#
# Cookbook Name:: Skills International
# Recipe:: default
#
# Copyright 2014, Skills International
#
# All rights reserved
#

env_name=node.chef_environment

databag = data_bag_item(env_name, "skills")

artifacts_root_url=databag['skills']['artifacts_root_url']

install_dir="#{node[:skills][:install_dir]}"

applicationName=databag["skills"]["application_name"]

bash "Create Config Directory" do
  cwd "/"
  code <<-EOH
  mkdir -p #{node[:skills][:conf_file]}
  EOH
end

remote_file "#{node[:skills][:conf_file]}/application.conf.erb" do
  source "#{artifacts_root_url}application.conf.erb"
  mode "0644"
  action :create
end

template "#{node[:skills][:conf_file]}/application.conf" do
  source "#{node[:skills][:conf_file]}/application.conf.erb"
  local true
  variables({
                :dbName => databag['skills']['db_name'],
                :smtpHost => databag['skills']['smtp_host'],
                :smtpPort => databag['skills']['smtp_port'],
                :smtSsl => databag['skills']['smt_ssl'],
                :smtpTls => databag['skills']['smtp_tls'],
                :smtpUser => databag['skills']['smtp_user'],
                :smtpPassword => databag['skills']['smtp_password'],
                :hostIp => databag['skills']['host_ip'],
                :hostUrl => databag['skills']['host_url'],
                :dbHost => databag['skills']['db_host'],
                :dbPort => databag['skills']['db_port'],
                :awsAccessKey => databag['skills']['awsAccessKey'],
                :awsSecretKey => databag['skills']['awsSecretKey'],
                :awsBucketOriginal => databag['skills']['awsBucketOriginal'],
                :httpProtocol => databag['skills']['httpProtocol'],
                :dbUser => databag['skills']['db_user'],
                :dbPassword => databag['skills']['db_password'],
            })
  action :create
end
#Added AWS values for key and pair
cookbook_file "#{node[:skills][:conf_file]}/logger.xml" do
  source "logger.xml"
  action :create
end

remote_file "#{install_dir}/#{applicationName}.zip" do
  source "#{artifacts_root_url}/skillsInternational-1.0-SNAPSHOT.zip"
  mode "0644"
  action :create
end

bash "unzip-#{applicationName}" do
  cwd "/#{node[:skills][:install_dir]}"
  code <<-EOH
    sudo rm -rf #{install_dir}/#{applicationName}
    sudo unzip #{install_dir}/#{applicationName}.zip
    sudo mv #{applicationName}*-* #{applicationName}
    sudo chmod +x #{install_dir}/#{applicationName}/bin/skillsinternational
  EOH
end


template "/etc/init.d/#{applicationName}" do
  source "initd.erb"
  owner "root"
  group "root"
  mode "0744"
  variables({
                :name => "#{applicationName}",
                :path => "#{node[:skills][:install_dir]}/#{applicationName}/bin",
                :pidFilePath => "#{node[:skills][:pid_file_path]}",
                :options => "-Dconfig.file=#{node[:skills][:conf_file]}/application.conf -Dpidfile.path=#{node[:skills][:pid_file_path]} -Dlogger.file=#{node[:skills][:conf_file]}/logger.xml",
                :command => "skillsinternational"
            })
end

service "#{applicationName}" do
  supports :stop => true, :start => true, :restart => true
  action [ :enable, :restart ]
end
