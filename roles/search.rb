name "search"
description "ElasticSearch server"
run_list ["recipe[java::oracle]","recipe[search]"]
