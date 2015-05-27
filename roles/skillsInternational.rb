name "skillsInternational"
description "Play application server for Skills International"
run_list ["recipe[java::oracle]","recipe[zip]","recipe[skillsInternational]","recipe[apt]","recipe[nginx::source]","recipe[skillsInternational::deploy-ui]"]
