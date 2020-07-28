yum -y install sudo
sudo yum -y install buildah
sudo yum -y install podman
sudo yum -y install skopeo
sudo yum -y install runc
sudo yum -y install slirp4netns
sudo yum module install -y container-tools

buildah bud -t ibmpipelines .
buildah images
buildah rm ibmpipelines-working-container
buildah from localhost/ibmpipelines
buildah containers
buildah run --tty ibmpipelines-working-container /bin/bash
