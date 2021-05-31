#!/bin/bash

echo "Defining Constants"
FOLDERS_TO_CREATE=("folder_to_delete_1" "folder_to_delete_2" "folder_to_keep")
FOLDERS_TO_DELETE=("folder_to_delete_1" "folder_to_delete_2")
CONTAINER_NAME="datalake"
RESOURCE_GROUP="rabosrrg"
STORAGE_ACCOUNT="rabosrsa${RANDOM}"

echo "Creating Resource Group and Storage account"
az group create \
	--resource-group $RESOURCE_GROUP \
	--location westeurope

az storage account create \
	--name $STORAGE_ACCOUNT \
	--resource-group $RESOURCE_GROUP \
	--location westeurope \
	--sku Standard_LRS 

echo "Creating storage container"
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT
for folder_name in ${FOLDERS_TO_CREATE[@]}
do
	echo 'creating folder:' $folder_name 'in container ' $CONTAINER_NAME
	az storage blob upload \
		--account-name $STORAGE_ACCOUNT \
		--container-name $CONTAINER_NAME \
		--name ${folder_name}/folder2/basic_file.txt \
		--file basic_file.txt
done

echo "Deleting subset of folders in Storage container"
for folder_name in ${FOLDERS_TO_DELETE[@]}
do
	echo 'deleting folder:' $folder_name 'in container ' $CONTAINER_NAME
	az storage blob delete-batch --account-name $STORAGE_ACCOUNT -s $CONTAINER_NAME --pattern ${folder_name}/*
done

