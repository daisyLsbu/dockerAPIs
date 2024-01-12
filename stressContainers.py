import docker
from random import randint

client = docker.from_env()

print("starting the container stress")

while 1:
 for epoch in range(10):
    for container in client.containers.list():
        print(container.short_id)
        cpu = randint(1, 5)
        io = randint(1, 3)
        mem = randint(1, 10)
        vm = randint(100, 300)
        cmd = f"""
                stress -c {cpu} -i {io} -m {mem} --vm-bytes {vm}M -t 10s
                """
        exit_code, output = container.exec_run(cmd)
        print(output)
