env_name=node.chef_environment

databag = data_bag_item(env_name, "proversity")

cookbook_file "#{node[:messaging][:data_dir]}/rabbit.json" do
            source "rabbit.json"
            mode "0644"
end


template "#{node[:messaging][:data_dir]}/rabbit.json" do
  source "rabbit.json.erb"
  variables({
                :recEngineRequestsQueue => databag['proversity']['requests_rec_engine_queue'],
                :requestExchange => databag['proversity']['rabbitmq_request_exchange'],
                :searchQueue => databag['proversity']['rabbitmq_search_queue'],
                :searchExchange => databag['proversity']['rabbitmq_search_exchange'],
		:recEngineSearchQueue => databag['proversity']['search_rec_engine_queue']
            })
end

bash "setup-exhanges-and-queues" do
  cwd "/#{node[:messaging][:data_dir]}"
  code <<-EOH
    sudo service rabbitmq-server restart
    sudo wget http://localhost:15672/cli/rabbitmqadmin
    sudo chmod u+x rabbitmqadmin
    sudo ./rabbitmqadmin import -q #{node[:messaging][:data_dir]}/rabbit.json
    sudo rm rabbitmqadmin
  EOH
end
