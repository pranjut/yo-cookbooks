lb_instances=`knife search node 'chef_environment:prod AND role:load_balancer' | grep FQDN | cut -d':' -f2 | tr -d ' '`

noOfInstances=`echo $lb_instances | wc -w`

echo "Found" $noOfInstances "Instances"

for (( i=1; i <= $noOfInstances; i++ )) do
        instance_name=`echo $lb_instances | cut -d ' ' -f$i`
        ssh -i ~/.ssh/proversity-sing.pem ubuntu@$instance_name bash update-lb-config.sh
done

echo "Successfully Updated Load Balancer Configuration"
