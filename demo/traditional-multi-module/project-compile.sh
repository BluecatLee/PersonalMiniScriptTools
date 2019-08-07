#!/bin/bash
HOME=/home/code
for i in $*
do
if [ $1 == "all" ];then
   cd $HOME/demo-java && git pull && cd $HOME/demo-java-app && git pull && cd $HOME/demo-living-payment && git pull 
elif [ $1 == "java" -o  $1 == "java-app" -o $1 == "living-payment" ];then
   cd ${HOME}/demo-$1 && git pull
elif [ $1 == "app" ];then
   mvn clean install -DskipTests -f /home/code/demo-java-app/pom.xml
elif [ $1 == "boss" ];then 
   mvn clean install -DskipTests -f /home/code/demo-java/pom.xml -pl demo_newboss_site -am
elif [ $1 == "mobile" ];then
   mvn clean install -DskipTests -f /home/code/demo-java/pom.xml -pl demo_mobile_site -am
elif [ $1 == "third" ];then
   mvn clean install -DskipTests -f /home/code/demo-java/pom.xml -pl demo_newthird_site -am
elif [ $1 == "site" ];then
   mvn clean install -DskipTests -f /home/code/demo-java/pom.xml -pl demo_site -am
elif [ $1 == "living-payment" ];then
   mvn clean install -DskipTests -f /home/code/demo-living-payment/pom.xml
elif [[ $1 == "search" ]]; then
   mvn clean install -DskipTests -f /home/code/demo-search/pom.xml
elif [ $1 == "allweb" ]; then
   mvn clean install -DskipTests -f /home/code/demo-java-app/pom.xml && mvn clean install -DskipTests -f /home/code/demo-java/pom.xml -pl demo_newboss_site -am && mvn clean install -DskipTests -f /home/code/demo-java/pom.xml -pl demo_mobile_site -am && mvn clean install -DskipTests -f /home/code/demo-java/pom.xml -pl demo_newthird_site -am && mvn clean install -DskipTests -f /home/code/demo-java/pom.xml -pl demo_site -am && mvn clean install -DskipTests -f /home/code/demo-living-payment/pom.xml
fi
shift
done
