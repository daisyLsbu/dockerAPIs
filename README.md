# dockerAPIs
Docker API usage: installation of docker and getting container metrics

Docker installation 
-------------------
1. Install Docker on your machine by following the instructions provided in the docker setup
2. To create your own cutom image folllow these steps:
### create custom image: install stress, python and add randomloop.py in container then build
sudo docker run -it ubuntu
sudo apt-get update -y
apt-get install -y stress-ng
apt-get install -y python3
chmod 777 looprandomstress.py 
docker cp looprandomstress.py 4d25f2399daa:/
docker images
docker image tag linuxubuntu-stress daisylsbu/linuxubuntu-stress:latest
docker image push daisylsbu/linuxubuntu-stress:latest

Notes:
Backup migrate and restore script for containers
Getting Container metrics using docker stats
