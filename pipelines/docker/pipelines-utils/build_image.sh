# install dependencies on infastructure node (run on first install)
#yum -y install sudo
#sudo yum -y install buildah
#sudo yum -y install podman
#sudo yum -y install skopeo
#sudo yum -y install runc
#sudo yum -y install slirp4netns
#sudo yum module install -y container-tools

# build redhat ubi from dockerfile
buildah bud -t ibmpipelines .

# display list of container images
buildah images

# delete already running container
buildah rm ibmpipelines-working-container

# build new pipelines container from image
buildah from localhost/ibmpipelines

# display list of all running containers
buildah containers

# ssh into ibm pipelines container shell
buildah run --tty ibmpipelines-working-container /bin/bash
