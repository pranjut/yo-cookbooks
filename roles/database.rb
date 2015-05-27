name "database"
description "Mysql database server"


run_list ["recipe[proversitydb::default]","recipe[proversitydb::db_bootstrap]"]