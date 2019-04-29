#!bin/bash

curl https://rclone.org/install.sh | sudo bash

rclone config create "armadillodata" azureblob --azureblob-account "armadillodata" --azureblob-key "0eLXiQ3QkegxejSdOU+VERtXc1CZmHmwte0c7FjYksZCGQTih+7wBBrswCmOW4YvCOkUpFsNGj7jCQBjGhrkPg=="

rclone sync /mnt/extstorage/k8s-nfs armadillodata:pi-nfs-data --progress  
