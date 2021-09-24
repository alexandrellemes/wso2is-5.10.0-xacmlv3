#!/bin/bash

cd /opt/wso2

echo 'Excluir maquinas ... fase 1'
sudo docker ps -a | awk '{ print $14 }' | xargs sudo docker rm $0
echo 'Excluir maquinas ... fase 2'
sudo docker ps -a | awk '{ print $15 }' | xargs sudo docker rm $0

sudo docker stop $(sudo docker ps -aq)
sudo docker rm $(sudo docker ps -aq)

#sudo docker pull carloshlemos/wso2is-5.10.0-xacmlv3
#sudo docker run -it -p 4000:4000 -p 9443:9443 -p 9763:9763 -d docker pull carloshlemos/wso2is-5.10.0-xacmlv3

#sudo docker-compose up -d --build
sudo docker-compose up -d

#sudo docker run -it -d node:12.0.0-slim
#sudo docker run -it -d -p 8080:80 nginx:1.13

# Limpa as imagens que n�o tem container associado.
# sudo docker image prune
# sudo docker image prune -a      

#- ./server/:/home/wso2carbon/wso2is-5.10.0/repository/deployment/server/
#/home/wso2carbon/wso2is-5.10.0/repository/deployment/server/webapps/authenticationendpoint #

sudo docker exec -it wso2 /bin/ash
apk update
apk add openssh
apk add rsync