
databag = data_bag_item("proversity", "proversity")

members=search(:node, "role:database")

db_node = members.first

internal_ip = db_node.has_key?("ec2") ? db_node["ec2"]["hostname"] : db_node["ipaddress"]


cookbook_file "/tmp/create_database.sql" do
  source "create_database.sql"
  mode 0755
  owner "root"
  group "root"
end

execute "db_bootstrap" do
  command "/usr/bin/mysql --user=#{databag['proversity']['db_username']} --password=#{databag['proversity']['db_password']} --host=#{internal_ip} --database=#{databag['proversity']['database']} < /tmp/create_database.sql"
  action :run
  notifies :create, "ruby_block[remove_dbapp_bootstrap]", :immediately
end

ruby_block "remove_dbapp_bootstrap" do
  block do
    Chef::Log.info("Database Bootstrap completed, removing the destructive recipe[dbapp::db_bootstrap]")
    node.run_list.remove("recipe[dbapp::db_bootstrap]") if node.run_list.include?("recipe[dbapp::db_bootstrap]")
  end
  action :nothing
end