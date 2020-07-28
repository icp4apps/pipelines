FROM registry.access.redhat.com/ubi8/ubi

# Specifying user metadata
USER root
LABEL maintainer="Peter Gramenides <Peter.Gramenides@ibm.com>"

# Updating the images for package installer
RUN yum update --disablerepo=* --enablerepo=ubi-8-appstream --enablerepo=ubi-8-baseos -y && rm -rf /var/cache/yum

# Making the dependency folders
RUN mkdir -p /scripts
RUN mkdir -p /packages

# Copying the scripts required by the pipelines and install_utilities.sh script
COPY /scripts/*.sh  /scripts/
RUN chmod +x /scripts/*.sh

# Copying the packages required by the pipelines
COPY /packages/*.rpm /packages/

# Executing the script to install the utility tools
RUN /scripts/install_utilities.sh
