# pipelines-utils

This is an image based on base image 'registry.access.redhat.com/ubi8/ubi' with utilities and tools installed that are used by Kabanero pipelines.

##Utilities installed
- kubectl
- jq
- skopeo
- sudo
- appsody
- buildah
- python2
- python3
- git
- gitopscli


##Scripts included in the image

 - [image_registry_access_setup.sh](https://github.ibm.com/IBMCloudPak4Apps/pipelines/blob/master/pipelines/docker/pipelines-utils/scripts/image_registry_access_setup.sh)      
 
 
 - [enforce_stack_policy.sh](https://github.ibm.com/IBMCloudPak4Apps/pipelines/blob/master/pipelines/docker/pipelines-utils/scripts/enforce_stack_policy.sh)
 
 
 - [enforce_deploy_stack_policy.sh](https://github.ibm.com/IBMCloudPak4Apps/pipelines/blob/master/pipelines/docker/pipelines-utils/scripts/enforce_deploy_stack_policy.sh)
 
 
 - [imageurl_imagename_lowercase.sh](https://github.ibm.com/IBMCloudPak4Apps/pipelines/blob/master/pipelines/docker/pipelines-utils/scripts/imageurl_imagename_lowercase.sh)
 
 
 - [stack_registry_url_setup.sh](https://github.ibm.com/IBMCloudPak4Apps/pipelines/blob/master/pipelines/docker/pipelines-utils/scripts/stack_registry_url_setup.sh)
 
 
 - [install_utilities.sh](https://github.ibm.com/IBMCloudPak4Apps/pipelines/blob/master/pipelines/docker/pipelines-utils/scripts/install_utilities.sh)
