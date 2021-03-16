# (C) Copyright IBM Corporation 2019, 2021
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
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

# delete already running container (optional)
#buildah rm ibmpipelines-working-container

# build new pipelines container from image
buildah from localhost/ibmpipelines

# display list of all running containers
buildah containers

# ssh into ibm pipelines container shell
buildah run --tty ibmpipelines-working-container /bin/bash
