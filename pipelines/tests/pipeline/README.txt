These are the instructions to install the kabanero-pipelines repo test pipeline, including the eventing setup

1. oc apply all the yaml files
2. Edit pipelines/pipelines/sample-helper-files/storage-samples/nfs-pv.yaml with the ip address of the cluster, and apply it
3. Run the pv.sh script
4. Create a ghe-https-secret in the kabanero namespace with a personal access token for the github the eventing infrastructure will use