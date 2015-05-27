cd /usr/src

dir_name="archives/build_billing$(date +'-%m-%d-%y-%H-%M')"

sudo mkdir $dir_name

sudo mv billing*.jar $dir_name

sudo wget --auth-no-challenge http://admin:88e3c6ef0e561eb9336ddbd98dd6a709@188.138.116.239:8080/jenkins/view/Development/job/billing-dev/default/ws/modules/billing/target/scala-2.10/billing_2.10-1.1.0-SNAPSHOT-one-jar.jar

sudo mv billing_2.10-1.1.0-SNAPSHOT-one-jar.jar billing-2.10-1.1.0-SNAPSHOT.jar

output=`ps aux|grep application_billing | grep -v grep |cut -d' ' -f6`
echo $output
if [ ${output:+1} ]
then
   echo "About to stop Billing running under pid " $output
   sudo kill $output
   sleep 5

   echo "Stopped Billing"
else
   echo "Billing is already stopped"
fi
echo "Starting Billing..."
sudo service billing start

started_process=`ps aux|grep billing`
echo $started_process
set -- $started_process

