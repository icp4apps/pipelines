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
wait

cd ..
git clone https://github.com/baloise/gitopscli.git
pip3 install gitopscli/
rm -rf gitopscli
cd packages

yum localinstall -y glibc-utils.rpm
wait
yum localinstall -y oniguruma.rpm
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
yum localinstall -y buildah.rpm
wait

cd ..
rm -rf packages

cd /usr/local/bin/
wget https://github.com/rhd-gitops-example/services/releases/download/v0.2.2/services_linux
mv services_linux services
chmod 755 services

echo "Cleaning up tendrils from installation..."
dnf clean all
rm -rf /var/cache/yum
yum clean all
wait

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo "Are the dependencies installed?"
if ! [ -x "$(command -v sudo)" ]; then
  echo -e "sudo: ${RED}FALSE${NC}"
else
	echo -e "sudo: ${GREEN}TRUE${NC}"
fi
if ! [ -x "$(command -v appsody)" ]; then
  echo -e "appsody: ${RED}FALSE${NC}"
else
	echo -e "appsody: ${GREEN}TRUE${NC}"
fi
if ! [ -x "$(command -v buildah)" ]; then
  echo -e "buildah: ${RED}FALSE${NC}"
else
	echo -e "buildah: ${GREEN}TRUE${NC}"
fi
if ! [ -x "$(command -v kubectl)" ]; then
  echo -e "kubectl: ${RED}FALSE${NC}"
else
	echo -e "kubectl: ${GREEN}TRUE${NC}"
fi
if ! [ -x "$(command -v python2)" ]; then
  echo -e "python2: ${RED}FALSE${NC}"
else
	echo -e "python2: ${GREEN}TRUE${NC}"
fi
if ! [ -x "$(command -v python3)" ]; then
  echo -e "python3: ${RED}FALSE${NC}"
else
	echo -e "python3: ${GREEN}TRUE${NC}"
fi
if ! [ -x "$(command -v git)" ]; then
  echo -e "git: ${RED}FALSE${NC}"
else
	echo -e "git: ${GREEN}TRUE${NC}"
fi
if ! [ -x "$(command -v jq)" ]; then
  echo -e "jq: ${RED}FALSE${NC}"
else
	echo -e "jq: ${GREEN}TRUE${NC}"
fi
if ! [ -x "$(command -v skopeo)" ]; then
  echo -e "skopeo: ${RED}FALSE${NC}"
else
	echo -e "skopeo: ${GREEN}TRUE${NC}"
fi
if ! [ -x "$(command -v gitopscli)" ]; then
  echo -e "gitopscli: ${RED}FALSE${NC}"
else
	echo -e "gitopscli: ${GREEN}TRUE${NC}"
fi
echo -e "If any packages are marked ${RED}FALSE${NC} there was an error."
echo "Installing and setting up dependencies completed. Packages include:"
echo "sudo, appsody, buildah, kubectl, python2, python3, git, jq, skopeo, gitopscli"
