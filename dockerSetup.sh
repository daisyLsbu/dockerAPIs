# this file can help setup docker and start the containers after downloading the prebuild container with existing stress python file to randomly stress the container.

#install docker
sudo apt -y install docker.io
#adding user to the groups 
sudo usermod -aG ubridge user
sudo usermod -aG libvirt user 
sudo usermod -aG kvm user
sudo usermod -aG wireshark user
sudo usermod -aG docker user
docker run hello-world #test docker
docker run -it ubuntu:latest  #to pull the image from internet and start container
docker stop <>
docker rm <>
#docker login
# pull custom image or follow steps to create one
#pull image from docker hub
docker pull username/repository:tag
#run container with volume mounting
sudo docker run -d 86a171db06e1 python3 looprandomstress.py #starting container with exec cmd in background
#copy migration script outside the folder
cp migrateVictim.py '/home/ubuntu/.'
cp transferimage.py '/home/ubuntu/.'
cp restoreimage.py '/home/ubuntu/.'

### create custom image: install stress, python and add randomloop.py in container then build
sudo docker run -it <image-id>
sudo docker cp file <container-id>:<path>/<file-name>
chmod +x file
install stress ng: apt update; apt-get install stress
test stress script:
commit: sudo docker commit <id> name:version
save: sudo docker save -o /home/user/test_ubuntu.img name:version

sudo docker load -i img-name
sudo docker run -d name:version
sudo docker exec <container-id> cmd
docker build -t my_image .  # this will create an image with name "my_image" and it's tag is latest, if you want to give a different
#checkin image to github 
docker commit <container id> username/repository:tag