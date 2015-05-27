cd /usr/src

dir_name="archives/build_proversity$(date +'-%m-%d-%y-%H-%M')"

sudo mkdir $dir_name

sudo mv proversity-1.1.0-SNAPSHOT.zip $dir_name

sudo mv *.jar $dir_name

sudo mv proversity.tar.gz $dir_name

sudo mv proversity $dir_name

sudo rm -rf proversity-1.1.0-SNAPSHOT

sudo wget --auth-no-challenge http://admin:88e3c6ef0e561eb9336ddbd98dd6a709@188.138.116.239:8080/jenkins/view/Development/job/proversity-development-dist/default/ws/dist/proversity-1.1.0-SNAPSHOT.zip

sudo unzip proversity-1.1.0-SNAPSHOT.zip

sudo chmod u+x proversity-1.1.0-SNAPSHOT/start

echo "Successfully Copied Artifacts"

output=`ps aux|grep proversity-1.1.0-SNAPSHOT | grep -v grep |cut -d' ' -f6`
echo $output
if [ ${output:+1} ]
then
   echo "About to stop Proversity running under pid " $output
   sudo kill $output
   sleep 5

   echo "Stopped Proversity"
else
   echo "Proversity is already stopped"
fi
echo "Starting proversity..."
sudo service proversity start

started_process=`ps aux|grep proversity-1.1.0-SNAPSHOT`
echo $started_process
set -- $started_process

