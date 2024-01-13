import subprocess as sbp
import sys

a = 'check'
victim_id = sys.argv[1]
victim_name = 'ubuntu-test'
backup_path = '/home/ubuntu/images/'
backup_img = 'ubuntu-test.img'

command = f"""
            echo {a}; 
            sudo docker --version;
            sudo docker images;
            sudo docker ps;
            sudo docker commit {victim_id}  {victim_name};
            sudo docker images;
            sudo docker ps -a;
            sudo docker ps;
            sudo docker save -o {backup_path}{backup_img} {victim_name};
            sudo docker ps;
            sudo docker stop {victim_id};
            sudo docker ps;
            sudo docker rm {victim_id};
            cd {backup_path};
            ls -lrt;
            sudo docker rmi {victim_name};
            """
# scp and delete file
ret = sbp.run(command, capture_output=True, shell=True)
print(ret.stdout.decode())