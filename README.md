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

### Docker API Wrapper

**Repository:** [`dockerAPI`](https://github.com/daisyLsbu/dockerAPI)

A Python wrapper around the Docker Engine API that abstracts the low-level calls needed for container inspection and live migration. This module is used by the Migration Orchestrator to perform the actual container move between hosts.

**What it does:**
- Queries running containers and their resource snapshots
- Identifies containers eligible for migration based on resource thresholds
- Initiates container checkpoint, transfer, and restore across hosts
- Handles Docker API authentication and connection management

**Key technologies:**
- Python
- Docker SDK / Docker Engine REST API

---
