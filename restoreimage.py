import subprocess as sbp

a = 'hello'
image_name = 'ubuntu-test:latest'
image_path = '/home/ubuntu/images/ubuntu-test.img'

command = f"""
            echo {a}; 
            sudo docker --version;
            sudo docker images;
            sudo docker ps;
            sudo docker load -i {image_path};
            sudo docker images;
            sudo docker run -d {image_name};            
            sudo docker images;
            sudo docker ps -a;
            sudo docker ps;
            pwd
            """

ret = sbp.run(command, capture_output=True, shell=True)
print(ret.stdout.decode())