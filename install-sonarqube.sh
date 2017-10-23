#!/bin/bash

# Fetch the variables
. parm.txt

# function to get the current time formatted
currentTime()
{
  date +"%Y-%m-%d %H:%M:%S";
}

sudo docker service scale devops-sonarqube=0
sudo docker service scale devops-sonarqubedb=0


echo ---$(currentTime)---populate the volumes---
#to zip, use: sudo tar zcvf devops_sonarqube_volume.tar.gz /var/nfs/volumes/devops_sonarqube*
sudo tar zxvf devops_sonarqube_volume.tar.gz -C /


echo ---$(currentTime)---create sonarqubedb service---
sudo docker service create -d \
--name devops-sonarqubedb \
--network $NETWORK_NAME \
--mount type=volume,source=devops_sonarqubedb_volume,destination=/var/lib/postgresql/data,\
volume-driver=local-persist,volume-opt=mountpoint=/var/nfs/volumes/devops_sonarqubedb_volume \
--replicas 1 \
--constraint 'node.role == manager' \
$SONARQUBEDB_IMAGE


echo ---$(currentTime)---create sonarqube service---
sudo docker service create -d \
--publish $SONARQUBE_PORT:9000 \
--name devops-sonarqube \
--mount type=volume,source=devops_sonarqube_volume_conf,destination=/opt/sonarqube/conf,\
volume-driver=local-persist,volume-opt=mountpoint=/var/nfs/volumes/devops_sonarqube_volume_conf \
--mount type=volume,source=devops_sonarqube_volume_data,destination=/opt/sonarqube/data,\
volume-driver=local-persist,volume-opt=mountpoint=/var/nfs/volumes/devops_sonarqube_volume_data \
--mount type=volume,source=devops_sonarqube_volume_extensions,destination=/opt/sonarqube/extensions,\
volume-driver=local-persist,volume-opt=mountpoint=/var/nfs/volumes/devops_sonarqube_volume_extensions \
--mount type=volume,source=devops_sonarqube_volume_bundled_plugins,destination=/opt/sonarqube/lib/bundled-plugins,\
volume-driver=local-persist,volume-opt=mountpoint=/var/nfs/volumes/devops_sonarqube_volume_bundled_plugins \
--network $NETWORK_NAME \
--replicas 1 \
--constraint 'node.role == manager' \
$SONARQUBE_IMAGE

sudo docker service scale devops-sonarqubedb=1
sudo docker service scale devops-sonarqube=1
