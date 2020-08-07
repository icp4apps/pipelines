#!/bin/bash

set -e


PIPELINES_SYNC_WORKSPACE=pipelines_sync_workspace

PIPELINES_GHE_REPO=https://github.ibm.com/IBMCloudPak4Apps/pipelines.git
PIPELINES_PUBLIC_REPO=https://github.com/icp4apps/pipelines.git
SYNC_BRANCH_NAME=merge_ghe_to_public_repo
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

echo "[INFO] Creating a branch out of cloned repo $PIPELINES_GHE_REPO master branch "
git branch $SYNC_BRANCH_NAME
if [ $? != 0 ]; then
   echo "[ERROR] Some error in creating a branch $SYNC_BRANCH_NAME out of the cloned repo $PIPELINES_GHE_REPO master branch"
   exit 1
else
   echo "[INFO] $SYNC_BRANCH_NAME Branch created successfully "
fi

echo "[INFO] checking out branch $SYNC_BRANCH_NAME"
git checkout $SYNC_BRANCH_NAME
if [ $? != 0 ]; then
   echo "[ERROR] Some error in checking out the branch $SYNC_BRANCH_NAME "
   exit 1
else
   echo "[INFO] $SYNC_BRANCH_NAME Branch checked out successfully "
fi

echo "[INFO] Adding all the files from the branch $SYNC_BRANCH_NAME"
git add .
if [ $? != 0 ]; then
   echo "[ERROR] Some error in adding all the files from the branch $SYNC_BRANCH_NAME that does not match with files from master branch of PIPELINES_PUBLIC_REPO=$PIPELINES_PUBLIC_REPO"
   exit 1
else
   echo "[INFO] Files from the branch $SYNC_BRANCH_NAME that differs with the files from the master branch of the repository $PIPELINES_PUBLIC_REPO was git added successfully before committing them "
fi

echo "[INFO] Printing all the added files"
git status

echo "Committing the changes of all the files that got added."
git commit -m "$MERGE_MESSAGE"
if [ $? != 0 ]; then
   echo "[ERROR] Some error in commiting all the files from the branch $SYNC_BRANCH_NAME before push to the PIPELINES_PUBLIC_REPO=$PIPELINES_PUBLIC_REPO"
   exit 1
else
   echo "[INFO] Files from the branch $SYNC_BRANCH_NAME commited successfully. "
fi

echo "[INFO] Pushing all the added files to the repository $PIPELINES_PUBLIC_REPO"
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
