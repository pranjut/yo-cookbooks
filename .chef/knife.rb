current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "barkat"
client_key               "#{current_dir}/barkat.pem"
validation_client_name   "pv-deploy-validator"
validation_key           "#{current_dir}/pv-deploy-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/pv-deploy"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]


