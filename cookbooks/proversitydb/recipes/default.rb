include_recipe "mysql::client"
include_recipe "mysql::server"
include_recipe "database::mysql"

databag = data_bag_item("proversity", "proversity")


mysql_database node['database'] do
  connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  action :create
end

mysql_database_user node['db_username'] do
  connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  password databag['proversity']['db_password']
  database_name databag['proversity']['database']
  host '%'
  privileges [:all]
  action :grant
end