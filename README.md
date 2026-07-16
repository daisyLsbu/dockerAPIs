# ContainerCreationMigration

> **Node-resident scripts for Docker environment setup and live container migration.**
> Deploy this repository on every host node in the network so the [Migration Orchestrator](https://github.com/daisyLsbu/MigrationOrchestrator) can trigger migration operations remotely over SSH.

---

## Table of Contents

- [What is This Repository?](#what-is-this-repository)
- [How It Fits Into the Broader System](#how-it-fits-into-the-broader-system)
- [Repository Contents](#repository-contents)
- [Part 1 — Docker Environment Setup](#part-1--docker-environment-setup)
  - [Install Docker and Pull the Stress Container](#install-docker-and-pull-the-stress-container)
  - [Building a Custom Stress Image from Scratch](#building-a-custom-stress-image-from-scratch)
- [Part 2 — Migration Scripts](#part-2--migration-scripts)
  - [migrateVictim.py — Stop and Export a Container](#migratevictimpy--stop-and-export-a-container)
  - [restoreimage.py — Load and Start a Container](#restoreimagepy--load-and-start-a-container)
- [Part 3 — Stress Workload](#part-3--stress-workload)
  - [randomloop.py — Random Resource Stress](#randomlooppy--random-resource-stress)
- [Deployment — Installing on Each Host Node](#deployment--installing-on-each-host-node)
- [How the Migration Orchestrator Uses These Scripts](#how-the-migration-orchestrator-uses-these-scripts)
- [Technologies Used](#technologies-used)

---

## What is This Repository?

This repository provides two things that must be present on **every host node** in the network:

**Docker environment setup** — a shell script that installs the Docker engine, configures user permissions, and pulls or builds the pre-configured stress container image used for load simulation.

**Migration operation scripts** — Python scripts that the [Migration Orchestrator](https://github.com/daisyLsbu/MigrationOrchestrator) invokes remotely (via SSH) to carry out the three steps of live container migration:

```
Source host                          Destination host
──────────────────                   ────────────────────
migrateVictim.py                →    restoreimage.py
(stop container,                     (load image,
 export image,                        start container)
 transfer via SSH)
```

Because the orchestrator connects to each node over SSH and executes these scripts directly, **this repository must be cloned and set up on every node before migration can work**.

---

## How It Fits Into the Broader System

This repo is one component of the [MigrationOrchesTelemetry](https://github.com/daisyLsbu/MigrationOrchesTelemtry) system:

```
┌─────────────────────────────────────────────────────┐
│  Each Host Node                                     │
│                                                     │
│  ┌──────────────────────┐  ┌──────────────────────┐ │
│  │  TelemetryApplication│  │ContainerCreation     │ │
│  │  (reports metrics)   │  │Migration             │ │
│  │                      │  │(executes migration   │ │
│  │                      │  │ ops when called      │ │
│  │                      │  │ remotely via SSH)    │ │
│  └──────────────────────┘  └──────────────────────┘ │
└─────────────────────────────────────────────────────┘
                    ▲ SSH calls
                    │
┌───────────────────┴─────────────────────────────────┐
│  Orchestration Node                                 │
│  MigrationOrchestrator  ←→  MonitoringApplication  │
└─────────────────────────────────────────────────────┘
```

The [MigrationOrchestrator](https://github.com/daisyLsbu/MigrationOrchestrator) decides *when* and *where* to migrate. This repo provides the scripts it calls on each node to make that happen.

---

## Repository Contents

| File | Type | Purpose |
|---|---|---|
| `dockerSetup.sh` | Shell | Installs Docker, sets user permissions, pulls the stress container image, copies migration scripts to the home directory |
| `migrateVictim.py` | Python | Stops a running container, exports its image as a tar file, transfers it to the destination host via SSH |
| `restoreimage.py` | Python | Loads the transferred image tar file and starts the container on the destination host |
| `randomloop.py` | Python | Runs inside containers — generates randomised CPU, I/O, and memory stress to simulate realistic workloads |

---

## Part 1 — Docker Environment Setup

### Install Docker and Pull the Stress Container

Run `dockerSetup.sh` once on each host node to install Docker and get everything ready:

```bash
bash dockerSetup.sh
```

The script performs the following steps:

```bash
# Install Docker engine
sudo apt -y install docker.io

# Add the user to the required groups
sudo usermod -aG ubridge user
sudo usermod -aG libvirt user
sudo usermod -aG kvm user
sudo usermod -aG wireshark user
sudo usermod -aG docker user

# Verify Docker is working
docker run hello-world

# Pull the pre-built stress container image from Docker Hub
sudo docker pull daisylsbu/ubuntustress:ver5

# Start a container running the stress workload script in the background
sudo docker run -d <image-id> python3 looprandomstress.py

# Copy the migration scripts to the home directory
cp migrateVictim.py '/home/ubuntu/.'
cp restoreimage.py '/home/ubuntu/.'
```

> The migration scripts are copied to `/home/ubuntu/` so the orchestrator can locate and execute them at a predictable path when connecting over SSH.

---

### Building a Custom Stress Image from Scratch

If you prefer to build the container image yourself rather than pulling the pre-built one from Docker Hub, follow these steps:

```bash
# Start a base Ubuntu container interactively
sudo docker run -it ubuntu

# Inside the container — install stress and Python
sudo apt-get update -y
apt-get install -y stress-ng
apt-get install -y python3

# Exit the container, then copy the stress script into it
docker cp looprandomstress.py <container-id>:/
chmod 777 looprandomstress.py
```

Tag and push the image to Docker Hub so it can be pulled on other nodes:

```bash
docker images
docker image tag linuxubuntu-stress daisylsbu/linuxubuntu-stress:latest
docker image push daisylsbu/linuxubuntu-stress:latest
```

---

## Part 2 — Migration Scripts

These scripts carry out the actual container migration. They are called remotely by the [MigrationOrchestrator](https://github.com/daisyLsbu/MigrationOrchestrator) via SSH and must exist at `/home/ubuntu/` on each node (placed there by `dockerSetup.sh`).

### migrateVictim.py — Stop and Export a Container

**Runs on: the source host (the over-utilised node)**

Called by the orchestrator when a migration decision is made. It:

1. Stops the identified container
2. Exports (saves) the container's image to a `.tar` file
3. Transfers the tar file to the destination host via SSH

The orchestrator passes the container ID and destination host IP as arguments when invoking this script remotely.

---

### restoreimage.py — Load and Start a Container

**Runs on: the destination host**

Called by the orchestrator after the image transfer is complete. It:

1. Loads the received `.tar` image file into Docker
2. Starts the container from the loaded image
3. Verifies the container is running

---

## Part 3 — Stress Workload

### randomloop.py — Random Resource Stress

This script runs **inside** the container as its primary process. It generates randomised CPU, I/O, memory, and virtual memory stress across multiple epochs using the `stress` command, simulating a realistic and variable workload.

This is what makes the containers useful as migration test subjects — they produce measurable, fluctuating resource usage that the monitoring system can observe and that the orchestrator can react to.

```bash
# The container is started with this script as its entry point
sudo docker run -d <image-id> python3 looprandomstress.py
```

---

## Deployment — Installing on Each Host Node

Clone this repository and run the setup script on every machine that will participate in the network:

```bash
# Clone the repository
git clone https://github.com/daisyLsbu/ContainerCreationMigration.git
cd ContainerCreationMigration

# Run setup (installs Docker, pulls image, copies migration scripts)
bash dockerSetup.sh
```

**Repeat on every host node.** The migration scripts must be present and Docker must be running on both the source and destination host for any migration to succeed.

---

## How the Migration Orchestrator Uses These Scripts

When the [MigrationOrchestrator](https://github.com/daisyLsbu/MigrationOrchestrator) decides to migrate a container from Host A to Host B, it executes the following sequence remotely over SSH:

```
Orchestrator
    │
    ├── SSH → Host A (source)
    │         python3 /home/ubuntu/migrateVictim.py <container_id> <host_b_ip>
    │         → stops container
    │         → exports image to tar
    │         → SCP tar to Host B
    │
    └── SSH → Host B (destination)
              python3 /home/ubuntu/restoreimage.py <image_tar_path>
              → loads image
              → starts container
```

The orchestrator does not need these scripts installed on itself — it only needs SSH access to each node where they are deployed.

---

## Technologies Used

| Component | Language | Key Tools |
|---|---|---|
| Docker environment setup | Shell | `docker`, `apt`, `usermod` |
| Container migration (source) | Python | Docker SDK, `subprocess`, SSH/SCP |
| Container migration (destination) | Python | Docker SDK |
| Stress workload | Python | `stress` / `stress-ng`, `os.system` |
