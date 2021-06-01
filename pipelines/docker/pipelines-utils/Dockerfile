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
FROM registry.access.redhat.com/ubi8/ubi

# Specifying user metadata
LABEL "name"="ibm-cloudpak4apps-pipelines"
LABEL "maintainer"="IBM"
LABEL "architecture"="x86_64"
LABEL "release"="0.15.0"
LABEL "version"="alpha.5"
LABEL "vendor"="IBM Corporation"
LABEL "description"="IBM Cloud Pak® for Applications helps you modernize existing applications, embed additional security, and develop new apps that unleash digital initiatives. It offers cloud-native development solutions that can quickly deliver value, along with flexible licensing that can be tailored to your specific needs."
LABEL "summary"="Pipelines for IBM Cloud Pak for Applications"
LABEL "io.k8s.display-name"="ibm-cloudpak4apps-pipelines"
LABEL "url"="https://www.ibm.com/cloud/cloud-pak-for-applications"
LABEL "com.redhat.license_terms"="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI"
LABEL "license"="Apache License"


# Updating the images for package installer
RUN yum update --disablerepo=* --enablerepo=ubi-8-appstream \
--enablerepo=ubi-8-baseos --setopt=tsflags=nodocs -y && \
rm -rf /var/cache/yum

# Making the dependency folders
RUN mkdir -p /scripts
RUN mkdir -p /packages
RUN mkdir -p /licenses

# Copying the scripts required by the pipelines and install_utilities.sh script
COPY /scripts/*.sh  /scripts/
RUN chmod +x /scripts/*.sh

# Copying the packages required by the pipelines
COPY /packages/*.rpm /packages/

# Copying the license required by Redhat and IBM
COPY /licenses/LICENSE /licenses/

# Executing the script to install the utility tools
RUN  /scripts/install_utilities.sh 

# remove metacopy- older linux version do not support - soln from : https://github.com/containers/podman/issues/3560
RUN sed -i s/,metacopy=on// /etc/containers/storage.conf

RUN echo "" >> /etc/containers/registries.conf
RUN echo "[registries.insecure]" >> /etc/containers/registries.conf
RUN echo "registries = []" >> /etc/containers/registries.conf
