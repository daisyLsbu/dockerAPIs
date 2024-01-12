import docker

client = docker.from_env()

print("starting the container stress")
while 1:
 for container in client.containers.list():
  print(container.short_id)
  exit_code, output = container.exec_run("python3 randomstress.py")
  print(output)
