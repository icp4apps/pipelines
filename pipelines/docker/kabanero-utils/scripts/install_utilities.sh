echo "Installing and setting up kubectl starting...."
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client

cat <<- "EOF" > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg

EOF

yum install -y sudo
yum install -y kubectl
yum install -y python2
yum install -y python3
yum install -y gcc
yum install -y git
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
yum localinstall -y ostree-devel.rpm
wait
yum localinstall -y containers-common.rpm
wait
yum localinstall -y jq.rpm
wait
yum localinstall -y skopeo.rpm
wait

cd ..
rm -rf packages

echo "Cleaning up tendrils from installation..."
dnf clean all
rm -rf /var/cache/yum
yum clean all

echo "Installing and setting up dependencies completed. Packages include:"
echo "sudo, kubectl, python2, python3, gcc, git, jq, skopeo, gitopscli"
