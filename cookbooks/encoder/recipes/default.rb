# default.rb
#

env_name=node.chef_environment

databag = data_bag_item(env_name, "proversity")

jenkins_root_url=databag['proversity']['jenkins_root_url']

remote_url =  databag['proversity']['encoder_remote_url']

app_version = databag['proversity']['encoder_app_version']


remote_file "#{node[:encoder][:install_dir]}/encoder-#{app_version}.jar" do
    source "#{jenkins_root_url}#{remote_url}encoder_#{app_version}-one-jar.jar"
    mode "0644"
    action :create_if_missing
end

cookbook_file "#{node[:encoder][:conf_file]}/application_encoder.conf" do
            source "application_encoder.conf"
            mode "0644"
end

cookbook_file "#{node[:encoder][:deploy_script]}/deploy-encoder.sh" do
  source "deploy-encoder.sh"
  mode "0744"
end

cookbook_file "#{node[:encoder][:conf_file]}/pk-APKAIEYLLZ5RNYA4DL7Q.der" do
  source "pk-APKAIEYLLZ5RNYA4DL7Q.der"
  mode "0644"
end

directory "#{node[:encoder][:deploy_script]}/#{node[:encoder][:appname]}_archives" do
  mode 00644
  action :create
end


template "#{node[:encoder][:deploy_script]}/deploy-encoder.sh" do
  source "deploy-encoder.sh.erb"
  variables({
                :install_dir => "#{node[:encoder][:install_dir]}",
                :app_version => "#{app_version}",
                :remote_url => "#{remote_url}",
                :rootUrl =>  "#{jenkins_root_url}",
                :app_name => "#{node[:encoder][:appname]}",
            })
end


template "#{node[:encoder][:conf_file]}/application_encoder.conf" do
        source "application_encoder.conf.erb"
        variables({
            :s3BucketOriginal => databag['proversity']['s3_bucket_original'],
            :s3BucketEncoded => databag['proversity']['s3_bucket_encoded'],
            :s3BucketThumbnails => databag['proversity']['s3_bucket_thumbnails'],
            :awsAccessKey => databag['proversity']['aws_access_key'],
            :awsSecretKey => databag['proversity']['aws_secret_key'],
            :streamingVideoDistribution => databag['proversity']['streaming_video_distribution'],
            :downloadVideoDistribution => databag['proversity']['download_video_distribution'],
            :publicKey => databag['proversity']['public_key'],
            :zencoderApiKey => databag['proversity']['zencoder_api_key'],
            :cloudfrontUrlExpirationPeriod => databag['proversity']['cloudfront_expiration_period'],
            :zencoderAppUrl => databag['proversity']['zencoder_app_url'],
            :envName => "databag['proversity']['environment_prefix']",
            :cloudfrontCanonicalUser => databag['proversity']['cloud_front_canonical_user'],
            :cloudfrontEncryptionKey => "#{node[:encoder][:conf_file]}/pk-APKAIEYLLZ5RNYA4DL7Q.der"
        })
end


template "/etc/init.d/#{node[:encoder][:appname]}" do
        source "initd.erb"
        owner "root"
        group "root"
        mode "0744"
        variables({
            :name => "#{node[:encoder][:appname]}",
            :path => "#{node[:encoder][:install_dir]}/encoder-#{app_version}.jar",
            :options => "-Dconfig.file=#{node[:encoder][:conf_file]}/application_encoder.conf",
            :command => "java -jar"
        })
end

service "#{node[:encoder][:appname]}" do
  supports :start => true
  action [ :enable, :start ]
end

bash "start-#{node[:encoder][:appname]}" do
        code "echo $JAVA_HOME"
end 

