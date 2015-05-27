name "application"
description "Play application server"
run_list ["recipe[java::oracle]","recipe[zip]","recipe[proversity-conf]","recipe[proversity]"]
