# this file can help setup docker and start the containers after downloading the prebuild container with existing stress python file to randomly stress the container.

#install docker
#add user to group
#docker login
#pull image from docker hub
#run container with volume mounting
sudo docker run -d 86a171db06e1 python3 looprandomstress.py
#copy migration script outside the folder
cp migrateVictim.py '/home/ubuntu/.'
cp transferimage.py '/home/ubuntu/.'
cp restoreimage.py '/home/ubuntu/.'