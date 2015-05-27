#
# Cookbook Name:: proversity
# Recipe:: default
#
# Copyright 2013, Proversity
#
# All rights reserved

env_name=node.chef_environment

databag = data_bag_item(env_name, "proversity")

jenkins_root_url=databag['proversity']['jenkins_root_url']

proversity_conf_remote_url =  databag['proversity']['proversity_conf_remote_url']

encoder_conf_remote_url =  databag['proversity']['encoder_conf_remote_url']

billing_conf_remote_url =  databag['proversity']['billing_conf_remote_url']

model_remote_url =  databag['proversity']['model_conf_remote_url']
  
bash "create-dir" do
  code <<-EOH
  sudo mkdir -p #{node[:proversity][:conf_file]}
  EOH
end

remote_file "#{node[:proversity][:conf_file]}/application.conf.erb" do
  source "#{jenkins_root_url}#{proversity_conf_remote_url}application.conf.erb"
  mode "0644"
  action :create
end


remote_file "#{node[:proversity][:conf_file]}/application_encoder.conf.erb" do
  source "#{jenkins_root_url}#{encoder_conf_remote_url}application_encoder.conf.erb"
  mode "0644"
  action :create
end


remote_file "#{node[:proversity][:conf_file]}/application_billing.conf.erb" do
  source "#{jenkins_root_url}#{billing_conf_remote_url}application_billing.conf.erb"
  mode "0644"
  action :create
end

remote_file "#{node[:proversity][:conf_file]}/pusher.conf" do
  source "#{jenkins_root_url}#{proversity_conf_remote_url}pusher.conf"
  mode "0644"
  action :create
end



remote_file "#{node[:proversity][:conf_file]}/model.conf.erb" do
  source "#{jenkins_root_url}#{model_remote_url}model.conf.erb"
  mode "0644"
  action :create
end

template "#{node[:proversity][:conf_file]}/logger.xml" do
  source "logger.xml.erb"
  variables({
                :smtpHostName => databag['proversity']['smtp_host_name'],
                :smtpPort => databag['proversity']['smtp_port'],
                :smtpUser => databag['proversity']['smtp_user'],
                :smtpPassword => databag['proversity']['smtp_password'],
                :smtpFromAddress => databag['proversity']['smtp_from_address'],
                :smtpReplyToAddress => databag['proversity']['smtp_reply_to_address'],
                :instance => databag['proversity']['instance_name']
            })
  action :create
end

template "#{node[:proversity][:conf_file]}/model.conf" do
  source "#{node[:proversity][:conf_file]}/model.conf.erb"
  local true
  variables({
                :s3BucketOriginal => databag['proversity']['s3_bucket_original'],
                :s3BucketEncoded => databag['proversity']['s3_bucket_encoded'],
                :s3BucketThumbnails => databag['proversity']['s3_bucket_thumbnails'],
                :imagesDistribution => databag['proversity']['images_distribution'],
                :uploadFolder => databag['proversity']['upload_folder'],
                :encodingHigh => databag['proversity']['proversity_profiles_encoding_high'],
                :encodingMain => databag['proversity']['proversity_profiles_encoding_main'],
                :encodingBaseline => databag['proversity']['proversity_profiles_encoding_baseline'],
                :encodingBaselineLow => databag['proversity']['proversity_profiles_encoding_baselinelow'],
                :encoding3gp => databag['proversity']['proversity_profiles_encoding_3gp'],
                :cloudfrontCanonicalUser => databag['proversity']['cloud_front_canonical_user'],
                :zencoderAppUrl => databag['proversity']['zencoder_app_url'],
                :envName => databag['proversity']['environment_prefix'],
                :cloudfrontUrlExpirationPeriod => databag['proversity']['cloudfront_expiration_period'],
                :zencoderApiKey => databag['proversity']['zencoder_api_key'],
                :payuMerchantKey => databag['proversity']['payu_merchant_key'],
                :payuHashSalt => databag['proversity']['payu_hash_salt'],
                :payuPgUrl => databag['proversity']['payu_pg_url'],
                :payuWsUrl => databag['proversity']['payu_ws_url'],
                :awsAccessKey => databag['proversity']['aws_access_key'],
                :awsSecretKey => databag['proversity']['aws_secret_key'],
                :smtpHostName => databag['proversity']['smtp_host_name'],
                :smtpPort => databag['proversity']['smtp_port'],
                :smtpUser => databag['proversity']['smtp_user'],
                :smtpPassword => databag['proversity']['smtp_password'],
                :smtpFromAddress => databag['proversity']['smtp_from_address'],
                :smtpReplyToAddress => databag['proversity']['smtp_reply_to_address'],
                :protocol => databag['proversity']['protocol'],
                :searchCluster => databag['proversity']['search_cluster'],
                :emailTokenValidityPeriod => databag['proversity']['token_validity_period']
            })
  action :create
end

template "#{node[:proversity][:conf_file]}/application_billing.conf" do
  source "#{node[:proversity][:conf_file]}/application_billing.conf.erb"
  local true
  variables({
                :databasehost => databag['proversity']['db_hostname'],
                :dbUserName => databag['proversity']['db_username'],
                :dbPassword => databag['proversity']['db_password'],
                :dbName => databag['proversity']['database'],
                :modelConfPath => "#{node[:proversity][:conf_file]}"
            })
  action :create
end



template "#{node[:proversity][:conf_file]}/application_encoder.conf" do
  source "#{node[:proversity][:conf_file]}/application_encoder.conf.erb"
  local true
  variables({
                :modelConfPath => "#{node[:proversity][:conf_file]}"
            })
  action :create
end

template "#{node[:proversity][:conf_file]}/application.conf" do
  source "#{node[:proversity][:conf_file]}/application.conf.erb"
  local true
  variables({
                :dbHostName => databag['proversity']['db_hostname'],
                :dbUserName => databag['proversity']['db_username'],
                :dbPassword => databag['proversity']['db_password'],
                :dbName => databag['proversity']['database'],
                :streamingVideoDistribution => databag['proversity']['streaming_video_distribution'],
                :downloadVideoDistribution => databag['proversity']['download_video_distribution'],
                :rabbitmqUrl => databag['proversity']['rabbitmq_host'],
                :encoderHost => databag['proversity']['local_host'],
                :billingHost => databag['proversity']['local_host'],
                :publicKey => databag['proversity']['public_key'],
                :encoderPort => databag['proversity']['encoder_port'],
                :billingPort => databag['proversity']['billing_port'],
                :imagesDistribution => databag['proversity']['images_distribution'],
                :uploadFolder => databag['proversity']['upload_folder'],
                :uiTheme => databag['proversity']['ui_theme'],
                :cloudfrontEncryptionKey => "#{node[:proversity][:conf_file]}/proversity.der",
                :mettlApiPublicKey => databag['proversity']['mettl_api_public_key'],
                :mettlApiPrivateKey => databag['proversity']['mettl_api_private_key'],
                :searchConfigPath => "#{node[:proversity][:searchconfig_path]}",
                :mettlAssessmentUrl => databag['proversity']['mettl_api_assessment_url'],
                :rabbitmqSearchExchange => databag['proversity']['rabbitmq_search_exchange'],
                :rabbitmqRequestExchange => databag['proversity']['rabbitmq_request_exchange'],
                :rabbitmqSearchQueue => databag['proversity']['rabbitmq_search_queue'],
                :envName => databag['proversity']['environment_prefix'],
                :redisHost => databag['proversity']['redis_host'],
                :cloudfrontUrlExpirationPeriod => databag['proversity']['cloudfront_expiration_period'],
                :assesmentResultInterval => databag['proversity']['mettl_assessment_result_interval'],
                :assesmentInterval => databag['proversity']['mettl_assessment_interval'],
                :proversityJndiName => databag['proversity']['proversity_jndi_name'],
                :yes => "true",
                :modelConfPath => "#{node[:proversity][:conf_file]}",
                :protocol => databag['proversity']['protocol'],
                :searchCluster => databag['proversity']['search_cluster'],
                :cdnDownloadDomain => databag['proversity']['cdn_download_domain'],
                :coursePurchasedInterval => databag['proversity']['course_purchase_interval'],
                :jobMatchingWithMyProfileInterval => databag['proversity']['jobMatching_WithMyProfile_Interval'],
                :remindMeForJobSubmissionInterval => databag['proversity']['remindMe_For_JobSubmission_Interval'],
                :sendMailForAnnouncementInterval => databag['proversity']['send_announcement_mail_Interval'],
                :expirePastSubmissionDateJobsInterval => databag['proversity']['expire_past_submission_date_interval'],
                :capturePaymentsInterval => databag['proversity']['capture_payments_interval'],
		:lmsUser => databag['proversity']['lms_user'],
                :lmsPassword => databag['proversity']['lms_password']
            })
  action :create
end

remote_file "#{node[:proversity][:searchconfig_path]}/sc_map.txt" do
  source "#{jenkins_root_url}#{proversity_conf_remote_url}sc_map.txt"
  mode "0644"
  action :create
end

remote_file "#{node[:proversity][:searchconfig_path]}/user_map.txt" do
  source "#{jenkins_root_url}#{proversity_conf_remote_url}user_map.txt"
  mode "0644"
  action :create
end

remote_file "#{node[:proversity][:searchconfig_path]}/job_map.txt" do
  source "#{jenkins_root_url}#{proversity_conf_remote_url}job_map.txt"
  mode "0644"
  action :create
end

remote_file "#{node[:proversity][:searchconfig_path]}/company_map.txt" do
  source "#{jenkins_root_url}#{proversity_conf_remote_url}company_map.txt"
  mode "0644"
  action :create
end
