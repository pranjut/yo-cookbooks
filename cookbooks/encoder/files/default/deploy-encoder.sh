cd /usr/src

dir_name="encoder/archives/build_encoder$(date +'-%m-%d-%y-%H-%M')"

sudo mkdir $dir_name

sudo mv encoder*.jar $dir_name

sudo wget --auth-no-challenge http://admin:88e3c6ef0e561eb9336ddbd98dd6a709@188.138.116.239:8080/jenkins/view/Development/job/encoder-dev/default/ws/modules/encoder/target/scala-2.10/encoder_2.10-1.1.0-SNAPSHOT-one-jar.jar

sudo mv encoder_2.10-1.1.0-SNAPSHOT-one-jar.jar encoder-2.10-1.1.0-SNAPSHOT.jar

output=`ps aux|grep application_encoder | grep -v grep |cut -d' ' -f6`
echo $output
if [ ${output:+1} ]
then
   echo "About to stop Encoder running under pid " $output
   sudo kill $output
   sleep 5

   echo "Stopped Encoder"
else
   echo "Encoder is already stopped"
fi
echo "Starting Encoder..."
sudo service encoder start

started_process=`ps aux|grep encoder`
echo $started_process
set -- $started_process

