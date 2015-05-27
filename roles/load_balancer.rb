name "load_balancer"
description "load balancer using nginx"

run_list ["recipe[apt]","recipe[nginx::source]","recipe[loadbalancer]"]

