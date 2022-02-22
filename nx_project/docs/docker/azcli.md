
```bash
##############################################
#Currently used commands to interact with the 
# Azure Container Registry
az acr login --name [AZURE_CONTAINER_NAME].azurecr.io

docker build --tag [AZURE_CONTAINER_NAME].azurecr.io/image:01122022 .
or
docker tag [IMAGE_TAG] [AZURE_CONTAINER_NAME].azurecr.io/image:01122022
```


