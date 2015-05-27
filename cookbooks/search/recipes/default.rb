# default.rb
#
remote_file "#{node[:elasticsearch][:install_dir]}/elasticsearch-#{node[:elasticsearch][:version]}.tar.gz" do
    source "#{node[:elasticsearch][:download_url]}elasticsearch-#{node[:elasticsearch][:version]}.tar.gz"
    mode "0644"
    action :create_if_missing
end




execute "uncompress-elasticsearch" do
  command "sudo tar xzvf #{node[:elasticsearch][:install_dir]}/elasticsearch-#{node[:elasticsearch][:version]}.tar.gz -C #{node[:elasticsearch][:install_dir]}/"
  action :run
end

template "/etc/init.d/#{node[:elasticsearch][:appname]}" do
        source "initd.erb"
        owner "root"
        group "root"
        mode "0744"
        variables({
            :name => "#{node[:elasticsearch][:appname]}",
            :path => "#{node[:elasticsearch][:install_dir]}/elasticsearch-#{node[:elasticsearch][:version]}/bin",
            :command => "sh elasticsearch"
        })
end

cookbook_file "#{node[:elasticsearch][:mapping_config]}/sc_map.txt" do
            source "sc_map.txt"
            mode "0644"
end

cookbook_file "#{node[:elasticsearch][:mapping_config]}/user_map.txt" do
            source "user_map.txt"
            mode "0644"
end

cookbook_file "#{node[:elasticsearch][:mapping_config]}/job_map.txt" do
            source "job_map.txt"
            mode "0644"
end


service "#{node[:elasticsearch][:appname]}" do
  supports :start => true
  action [ :enable, :start ]
end

#bash "setup-elasticsearch-indexes" do

#  code <<-EOH

#    sudo sh #{node[:elasticsearch][:install_dir]}/elasticsearch-#{node[:elasticsearch][:version]}/bin/elasticsearch

#    curl -XPUT 'http://localhost:9200/proversity/'

#    curl -XPUT 'http://localhost:9200/proversity/sc/_mapping' -d @/#{node[:elasticsearch][:mapping_config]}/sc_map.txt

#    curl -XPUT 'http://localhost:9200/proversity/user/_mapping' -d @/#{node[:elasticsearch][:mapping_config]}/user_map.txt

#    curl -XPUT 'http://localhost:9200/proversity/job/_mapping' -d @/#{node[:elasticsearch][:mapping_config]}/job_map.txt

#EOH
#end


