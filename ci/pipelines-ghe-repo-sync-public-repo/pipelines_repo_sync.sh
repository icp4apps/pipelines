#!/bin/bash
#This script will clone the [GHE pipelines repository](https://github.ibm.com/IBMCloudPak4Apps/pipelines) code base 
#and sync it to the [public pipelines repository](https://github.com/icp4apps/pipelines) using GIT commands.
set -e


PIPELINES_SYNC_WORKSPACE=pipelines_sync_workspace

PIPELINES_GHE_REPO=https://github.ibm.com/IBMCloudPak4Apps/pipelines.git
PIPELINES_PUBLIC_REPO=https://github.com/icp4apps/pipelines.git
TIMESTAMP=$(date +"%d/%m/%Y_%H:%M:%S")
SYNC_BRANCH_NAME=merge_ghe_code_to_public_repo_code_$TIMESTAMP
MERGE_MESSAGE="merge ghe files to public pipelines repo"

cleanup_workingspace_dir() {
   cd ../../
   if [ -d "$PIPELINES_SYNC_WORKSPACE" ]; then
      rm -Rf $PIPELINES_SYNC_WORKSPACE
   fi
}

setup_workingspace_dir() {
   echo "[INFO] Creating a directory $PIPELINES_SYNC_WORKSPACE"
   if [ -d "$PIPELINES_SYNC_WORKSPACE" ]; then
      rm -Rf $PIPELINES_SYNC_WORKSPACE
   fi
   mkdir -p $PIPELINES_SYNC_WORKSPACE
   cd $PIPELINES_SYNC_WORKSPACE
}

echo "[INFO] Setting up directory PIPELINES_SYNC_WORKSPACE=$PIPELINES_SYNC_WORKSPACE"
setup_workingspace_dir

echo "[INFO] Cloning the ghe pipelines repo $PIPELINES_GHE_REPO"

git clone $PIPELINES_GHE_REPO
if [ $? != 0 ]; then
   echo "[ERROR] some issue while cloning the pipelines GHE repository "
   exit 1
else
   echo "[INFO] GHE repo $PIPELINES_GHE_REPO was cloned successfully"
fi


cd pipelines/

git remote set-url origin $PIPELINES_PUBLIC_REPO
if [ $? != 0 ]; then
   echo "[ERROR] Some error in setting the remote origin as  $PIPELINES_PUBLIC_REPO"
   exit 1
else
   echo "[INFO] Remote origin was set successfully to $PIPELINES_PUBLIC_REPO"
fi


echo "[INFO] checking out branch $SYNC_BRANCH_NAME"
git checkout -b $SYNC_BRANCH_NAME
if [ $? != 0 ]; then
   echo "[ERROR] Some error in checking out the branch $SYNC_BRANCH_NAME "
   exit 1
else
   echo "[INFO] $SYNC_BRANCH_NAME Branch checked out successfully "
fi


echo "[INFO] Pushing the changes to the repository $PIPELINES_PUBLIC_REPO"
git push origin $SYNC_BRANCH_NAME
if [ $? != 0 ]; then
   echo "[ERROR] Some error in pushing all the comitted files from the branch $SYNC_BRANCH_NAME to the PIPELINES_PUBLIC_REPO=$PIPELINES_PUBLIC_REPO"
   exit 1
else
   echo "[INFO] Pushed all the comitted files from the branch $SYNC_BRANCH_NAME to the repository PIPELINES_PUBLIC_REPO=$PIPELINES_PUBLIC_REPO successfully. "
fi

echo "[INFO] Please go to the repository $PIPELINES_PUBLIC_REPO and create a pull request to sync the pushed merged changes from the repository $PIPELINES_GHE_REPO"

echo "[INFO] Cleaning up working space directory $PIPELINES_SYNC_WORKSPACE"
cleanup_workingspace_dir
