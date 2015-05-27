#!/bin/bash
UBUNTU_HOME=/home/ubuntu
sudo rm -rf /etc/chef/client.pem

sudo apt-get -y install redis-server >> redis-output.txt

sudo bash -c 'sed "/node_name/d" /etc/chef/client.rb > /etc/chef/temp.rb'
sudo bash -c 'cat /etc/chef/temp.rb > /etc/chef/client.rb'
sudo bash -c 'instance_id=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`
export EC2_HOME="/home/ubuntu/ec2-api-tools" 
export JAVA_HOME="/usr"
export AWS_ACCESS_KEY=AKIAJPN5FNZBOCYDB3QQ
export AWS_SECRET_KEY=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
echo node_name \"$instance_id\" >> /etc/chef/client.rb
$EC2_HOME/bin/ec2-associate-address -i $instance_id 54.221.205.133'

sudo rm -rf /etc/chef/temp.rb

sudo bash -c 'cat > /etc/chef/first-boot.json << EOL
{"run_list": ["recipe[java::oracle]","recipe[zip]","recipe[proversity-conf]","recipe[proversity]","recipe[rabbitmq::mgmt_console]","recipe[proversity_messaging]","recipe[apt]","recipe[nginx::source]","recipe[loadbalancer]"]}
EOL'

sudo bash -c 'cat > /etc/chef/massmailer.json << EOL
{"run_list": ["recipe[massmailer]"]}
EOL'
echo sudo chef-client -j /etc/chef/first-boot.json -E alpha > deploy.sh
echo sudo chef-client -j /etc/chef/massmailer.json -E alpha > deploy-massmailer.sh
mv deploy*.sh $UBUNTU_HOME/
chmod +x $UBUNTU_HOME/deploy*.sh
nohup sh $UBUNTU_HOME/deploy.sh & > $UBUNTU_HOME/chef-log.txt

nohup sh $UBUNTU_HOME/deploy-massmailer.sh & > $UBUNTU_HOME/massmailer_log.txt
