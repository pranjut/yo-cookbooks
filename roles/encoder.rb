name "encoder"
description "Encoder App"
run_list ["recipe[java::oracle]","recipe[encoder]"]
