name "messaging"
description "RabbitMQ message server"
run_list ["recipe[rabbitmq::mgmt_console]","recipe[proversity_messaging]"]
