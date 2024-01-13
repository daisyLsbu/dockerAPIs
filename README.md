# dockerAPIs
Docker API usage: installation of docker and getting container metrics

Docker installation 
-------------------
1. Install Docker on your machine by following the instructions provided in the docker setup
2. To create your own cutom image folllow these steps:
### create custom image: install stress, python and add randomloop.py in container then build
sudo docker run -it <image-id>
sudo docker cp file <container-id>:<path>/<file-name>
chmod +x file
install stress ng: apt update; apt-get install stress
test stress script: stress -c 2 -i 1 -m 1 --vm-bytes 128M -t 10s

commit: sudo docker commit <id> name:version
save: sudo docker save -o /home/user/test_ubuntu.img name:version

sudo docker load -i img-name
sudo docker run -d name:version
sudo docker exec <container-id> cmd
docker build -t my_image .  # this will create an image with name "my_image" and it's tag is latest, if you want to give a different
#Uploading to GitHub cloud
docker commit <container id> username/repository:tag
docker push username/repository:tag

Notes:
Backup migrate and restore script for containers
Getting Container metrics using docker stats
