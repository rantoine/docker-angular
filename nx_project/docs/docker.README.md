# Local Development w/ Docker
=================================

---
#### Without docker-compose:

```bash
# Build Images
docker build --tag [IMAGE_NAME] .

# Run Container and watch process
docker run --name [IMAGE_NAME] --publish 4200:4200 [IMAGE_NAME]

# Run Container in Background (there are shorthand versions of the following)
docker run --detach --name [IMAGE_NAME] --publish 4200:4200 [IMAGE_NAME]

# Run Container - shorthand version
docker run -d -p 4200:4200 --name [IMAGE_NAME] [IMAGE_NAME]

# Use the below URLs in your browser if running locally
# If using play-with-docker click the port numbers near the top of the page
Nx Project:
http://localhost:4200
or
curl -s http://localhost:4200

# Stop Containers
docker stop [IMAGE_NAME]
docker rm [IMAGE_NAME]

# Remove Image
docker rmi [IMAGE_NAME]
```
---

#### With docker-compose:

```bash
# Create and Start Container Watching
docker-compose up

# Create and Start Container in Background
docker-compose up -d

# Use the below URLs in your browser
Nx Project:
http://localhost:4200

or
curl -s http://localhost:4200

# Stop Container
docker-compose stop
docker-compose rm -f
```
---

#### Cleaning Up your local docker environment:

```bash
# All of the following can be managed from the Docker Dashboard
# Or if you like to manage from the CLI you can try the following
# The CLI gives a lot more information and much easier to access

# View all Running/Stopped Containers
docker ps --all

# View locally created images
docker image ls

# Overall Docker System Details (Lots of good info)
docker system info

# Learning About Your Images
docker image inspect {IMAGE ID} # Get ID from list command above

# The 'official' Docker cleanup method
# Delete Stopped Containers, And Volumes And Networks That Are Not Used By Containers
docker system prune --all --volumes

# Generally safe cleanup commands
----------------------------------
# Delete Orphaned And Dangling Volumes
docker volume rm $(docker volume ls -qf dangling=true)

# Delete Dangling And Untagged Images
docker rmi -f $(docker images -q -f dangling=true)

# Cleanup commands, if you know what you're doing OR like living on the edge
----------------------------------------------------------------------------
# Kill All Running Containers
docker kill $(docker ps -q)

# Delete Exited Containers
docker rm $(docker ps -aqf status=exited)

# Delete All Images
docker rmi -f $(docker images -q)

# Delete All Containers
docker rm -f $(docker ps -aq)
```

#### Azure Docker Container Registery: 

- [Docker Docs](https://docs.docker.com/)
- [Azure Container Registry](https://azure.microsoft.com/en-us/services/container-registry/)

```bash
# URL: [AZURE_CONTAINER_NAME].azurecr.io

# Login via Azure CLI is required:
az acr login --name [AZURE_CONTAINER_NAME].azurecr.io

# Running the Garage-UI image from the DD Container Registery:
docker run -p 4200:4200 [AZURE_CONTAINER_NAME].azurecr.io/[IMAGE_NAME]:latest

# Build and Tag a new version of the Garage UI
docker build --tag [AZURE_CONTAINER_NAME].azurecr.io/[IMAGE_NAME]:v1 . 

# Pushing the latest build of the Garage UI
docker push [AZURE_CONTAINER_NAME].azurecr.io/[IMAGE_NAME]:latest
```

```bash
#Running the Garage UI from a personal computer as a non-engineering participant
docker login [AZURE_CONTAINER_NAME].azurecr.io -u 8c45408e-5b65-4434-bf32-834b500149d3 -p ********************

#Example command for running the "Latest" build of the Garage UI
docker run -p 4200:4200 [AZURE_CONTAINER_NAME].azurecr.io/[IMAGE_NAME]:latest
```