#!bin/bash

# Source env vars
source env_vars.sh

curl https://rclone.org/install.sh | sudo bash

rclone config create $rclone_CONFIG_NAME azureblob --azureblob-account $AZURE_BLOB_ACCOUNT --azureblob-key $AZURE_BLOB_KEY

rclone sync $SERVER_NFS_MOUNT $AZURE_BLOB_ACCOUNT:pi-nfs-data --progress  
