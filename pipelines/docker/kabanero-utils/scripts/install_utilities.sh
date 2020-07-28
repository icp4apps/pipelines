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
yum install -y gcc

cd ..
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


echo "Installing and setting up kubectl, python2, jq and skopeo tool completed"