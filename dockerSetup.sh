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
sudo docker pull daisylsbu/ubuntustress:ver5
#docker pull username/repository:tag
#run container with volume mounting; update script to run dockersetup.sh with n= number of containers
sudo docker run -d 86a171db06e1 python3 looprandomstress.py #starting container with exec cmd in background
#copy migration script outside the folder
cp migrateVictim.py '/home/ubuntu/.'
cp restoreimage.py '/home/ubuntu/.'