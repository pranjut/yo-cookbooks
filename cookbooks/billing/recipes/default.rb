# default.rb
#
env_name=node.chef_environment

databag = data_bag_item(env_name, "proversity")

remote_url =  databag['proversity']['billing_remote_url']

jenkins_root_url=databag['proversity']['jenkins_root_url']

app_version = databag['proversity']['billing_app_version']

remote_file "#{node[:billing][:install_dir]}/billing-#{app_version}.jar" do
    source "#{jenkins_root_url}#{remote_url}billing_#{app_version}-one-jar.jar"
    mode "0644"
    action :create_if_missing
end

cookbook_file "#{node[:billing][:conf_file]}/application_billing.conf" do
            source "application_billing.conf"
            mode "0644"
end

cookbook_file "#{node[:billing][:deploy_script]}/deploy-billing.sh" do
  source "deploy-billing.sh"
  mode "0744"
end

directory "#{node[:billing][:deploy_script]}/#{node[:billing][:appname]}_archives" do
  mode 00644
  action :create
end


template "#{node[:billing][:deploy_script]}/deploy-billing.sh" do
  source "deploy-billing.sh.erb"
  variables({
                :install_dir => "#{node[:billing][:install_dir]}",
                :app_version => "#{app_version}",
                :remote_url => "#{remote_url}",
                :root_url => "#{jenkins_root_url}",
                :app_name => "#{node[:billing][:appname]}",
            })
end

template "#{node[:billing][:conf_file]}/application_billing.conf" do
        source "application_billing.conf.erb"
        variables({
            :databasehost => databag['proversity']['db_hostname'],
            :dbUserName => databag['proversity']['db_username'],
            :dbPassword => databag['proversity']['db_password'],
            :dbName => databag['proversity']['database'],
            :s3BucketOriginal => databag['proversity']['s3_bucket_original'],
            :s3BucketEncoded => databag['proversity']['s3_bucket_encoded'],
            :s3BucketThumbnails => databag['proversity']['s3_bucket_thumbnails'],
            :awsAccessKey => databag['proversity']['aws_access_key'],
            :awsSecretKey => databag['proversity']['aws_secret_key'],
            :streamingVideoDistribution => databag['proversity']['streaming_video_distribution'],
            :downloadVideoDistribution => databag['proversity']['download_video_distribution'],
            :publicKey => databag['proversity']['public_key'],
            :zencoderApiKey => databag['proversity']['zencoder_api_key']
        })
end


template "/etc/init.d/#{node[:billing][:appname]}" do
        source "initd.erb"
        owner "root"
        group "root"
        mode "0744"
        variables({
            :name => "#{node[:billing][:appname]}",
            :path => "#{node[:billing][:install_dir]}/billing-#{app_version}.jar",
            :options => "-Dconfig.file=#{node[:billing][:conf_file]}/application_billing.conf",
            :command => "java -jar"
        })
end


service "#{node[:billing][:appname]}" do
  supports :start => true
  action [ :enable, :start ]
end

bash "start-#{node[:billing][:appname]}" do
        code "echo $JAVA_HOME"
end 

