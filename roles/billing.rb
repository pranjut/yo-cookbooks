name "billing"
description "Billing App"
run_list ["recipe[java::oracle]","recipe[billing]"]
