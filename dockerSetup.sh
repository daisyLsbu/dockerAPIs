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
docker run -it ubuntu:latest  #to pull the image from internet 
docker stop <>
docker rm <>
#docker login
#create custom image
docker build -t my_image .  # this will create an image with name "my_image" and it's tag is latest, if you want to give a different
#checkin image to github 
docker commit <container id> username/repository:tag
#pull image from docker hub
docker pull username/repository:tag
#run container with volume mounting
sudo docker run -d 86a171db06e1 python3 looprandomstress.py -- starting the  same image again using image id
#copy migration script outside the folder
cp migrateVictim.py '/home/ubuntu/.'
cp transferimage.py '/home/ubuntu/.'
cp restoreimage.py '/home/ubuntu/.'