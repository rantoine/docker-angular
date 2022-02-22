#!/bin/bash
server=[AZURE_CONTAINER_NAME].azurecr.io
image=[IMAGE_NAME]
branch=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)
currentDate=$(date +%F) 
tag="$server/$image-$currentDate"

#########################################
# Build the appropriate Docker Image Tags
if [ $branch = "main" ]
then 
 echo -e "Building the Production Docker image: $branch\r\n"
 tag=" -t $server/$image:latest -t $server/$image:$branch-$currentDate -t $server/$image:$currentDate"
elif [ $branch = "dev" ]
then 
 echo -e "Building the Docker image for the branch: $branch\r\n"
 tag=" -t $server/$image:$branch -t $server/$image:$branch-$currentDate"
else
 echo -e "Building the Docker image for a feature branch: $branch\r\n"
 tag=" -t $server/$image:$branch -t $server/$image:$branch-$currentDate"
fi

################################################
# Build the docker image with the assigned tags 
# from the logic above
echo -e "Building the Docker Image: $tag\r\n"
docker build -f Dockerfile.build $tag .
echo "\n\n"

#########################################
# Login to the Azure Container Registry 
echo -e "Logging in to AZURE $server\r\n"
az acr login --name $server
echo "\n\n"

########################################
# Push the newly created images to the 
# Container Registry
echo -e "Pushing the Docker Image $tag to the Server $server"
docker push $server/$image --all-tags
echo "\n\n"

