KUBE_CLIENT_VERSION="11.0.0"

yum install -y sudo
echo "Installing and setting up kubectl starting...."
cat <<- "EOF" > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg

EOF


yum install -y kubectl
yum install -y python2
yum install -y python3
yum install -y git
yum install -y wget
yum install -y pcre2
yum install -y sqlite-libs
yum install -y libgcrypt
yum install -y libsolv
yum install -y libcurl
yum install -y curl
yum install -y expat
yum install -y libpcap
yum install -y libssh
yum install -y gnutls
yum install -y libarchive
yum install -y gnupg2
yum install -y vim-minimal
yum install -y cryptsetup-libs
yum install -y openssl-libs
yum install -y cyrus-sasl-lib
yum install -y libxml2-devel
yum install -y python3-libxml2
yum install -y python3-libs
yum install -y platform-python
yum install -y glibc-common
yum install -y glibc-utils
yum install -y glibc-minimal-langpack
yum install -y glibc
yum install -y systemd-libs
yum install -y systemd
yum install -y systemd-pam

wait

pip2 install --no-cache-dir -U passlib
pip2 install --no-cache-dir -U requests
pip2 install --no-cache-dir -U kubernetes==${KUBE_CLIENT_VERSION}
# pip2 install --no-cache-dir -U kubernetes

pip3 install --no-cache-dir -U passlib
pip3 install --no-cache-dir -U requests
pip3 install --no-cache-dir -U kubernetes==${KUBE_CLIENT_VERSION}
# pip3 install --no-cache-dir -U kubernetes
pip3 install --no-cache-dir -U go_template
pip3 install --no-cache-dir -U yq

cd ..

# Not doing gitops at this time
# git clone https://github.com/baloise/gitopscli.git
# pip3 install gitopscli/
# rm -rf gitopscli

cd packages

yum localinstall -y glibc-utils.rpm
wait
yum install -y oniguruma
wait
yum localinstall -y libslirp.rpm
wait 
yum localinstall -y slirp4netns.rpm
wait
yum localinstall -y ostree-devel.rpm
wait
yum localinstall -y containers-common.rpm
wait
yum localinstall -y container-selinux.rpm
wait
yum localinstall -y device-mapper-libs.rpm
wait
yum localinstall -y glibc-utils.rpm
wait
yum localinstall -y libassuan.rpm
wait
yum localinstall -y libgpg-error.rpm
wait
yum localinstall -y libnet.rpm
wait
yum localinstall -y protobuf.rpm
wait
yum localinstall -y protobufc.rpm
wait
yum localinstall -y criu.rpm
wait
yum localinstall -y runc.rpm
wait
yum localinstall -y jq.rpm
wait
yum localinstall -y skopeo.rpm
wait
yum localinstall -y appsody.rpm
wait

# Install non-offical release of buildah to get around problem of buildah failure
# yum localinstall -y buildah.rpm
# wait

dnf -y module disable container-tools
dnf -y install 'dnf-command(copr)'
dnf -y copr enable rhcontainerbot/container-selinux
curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/CentOS_8/devel:kubic:libcontainers:stable.repo
dnf -y install buildah


cd ..
rm -rf packages

# cd /usr/local/bin/
# wget https://github.com/rhd-gitops-example/services/releases/download/v0.2.2/services_linux
# mv services_linux services
# chmod 755 services

echo "Cleaning up tendrils from installation..."
dnf clean all
rm -rf /var/cache/yum
yum clean all
wait

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
all_installed=true

echo "Are the dependencies installed?"
if ! [ -x "$(command -v sudo)" ]; then
  all_installed=false
  echo -e "sudo: ${RED}FALSE${NC}"
else
	echo -e "sudo: ${GREEN}TRUE${NC}"
fi
if ! [ -x "$(command -v appsody)" ]; then
  all_installed=false
  echo -e "appsody: ${RED}FALSE${NC}"
else
	echo -e "appsody: ${GREEN}TRUE${NC}"
fi
if ! [ -x "$(command -v buildah)" ]; then
  all_installed=false
  echo -e "buildah: ${RED}FALSE${NC}"
else
	echo -e "buildah: ${GREEN}TRUE${NC}"
fi
if ! [ -x "$(command -v kubectl)" ]; then
  all_installed=false
  echo -e "kubectl: ${RED}FALSE${NC}"
else
	echo -e "kubectl: ${GREEN}TRUE${NC}"
fi
if ! [ -x "$(command -v python2)" ]; then
  all_installed=false
  echo -e "python2: ${RED}FALSE${NC}"
else
	echo -e "python2: ${GREEN}TRUE${NC}"
fi
if ! [ -x "$(command -v python3)" ]; then
  all_installed=false
  echo -e "python3: ${RED}FALSE${NC}"
else
	echo -e "python3: ${GREEN}TRUE${NC}"
fi
if ! [ -x "$(command -v git)" ]; then
  all_installed=false
  echo -e "git: ${RED}FALSE${NC}"
else
	echo -e "git: ${GREEN}TRUE${NC}"
fi
if ! [ -x "$(command -v jq)" ]; then
  all_installed=false
  echo -e "jq: ${RED}FALSE${NC}"
else
	echo -e "jq: ${GREEN}TRUE${NC}"
fi
if ! [ -x "$(command -v skopeo)" ]; then
  all_installed=false
  echo -e "skopeo: ${RED}FALSE${NC}"
else
	echo -e "skopeo: ${GREEN}TRUE${NC}"
fi
# if ! [ -x "$(command -v gitopscli)" ]; then
#   echo -e "gitopscli: ${RED}FALSE${NC}"
# else
# 	echo -e "gitopscli: ${GREEN}TRUE${NC}"
# fi



echo -e "If any packages are marked ${RED}FALSE${NC} there was an error."
echo "Installing and setting up dependencies completed. Packages include:"
# echo "sudo, appsody, buildah, kubectl, python2, python3, git, jq, skopeo, gitopscli"
echo "sudo, appsody, buildah, kubectl, python2, python3, git, jq, skopeo"
if [ "$all_installed" = false ]; then
  echo -e "Resolve the failed dependecies"
  exit 1
fi
