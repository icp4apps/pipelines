#!/bin/bash
set -e

# setup environment
. $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/env.sh

# expose an extension point for running before main 'package' processing
exec_hooks $script_dir/ext/pre_package.d


eventing_pipelines_dir=$base_dir/pipelines/incubator/events
odo_pipelines_dir=$base_dir/pipelines/experimental/odotechpreview


# directory to store assets for test or release
assets_dir=$base_dir/ci/assets
mkdir -p $assets_dir

package() {
    local pipelines_dir=$1
    local prefix=$2
    echo -e "--- Creating pipeline artifacts for $prefix"
    # Generate a manifest.yaml file for each file in the tar.gz file
    asset_manifest=$pipelines_dir/manifest.yaml
    echo "contents:" > $asset_manifest

    # for each of the assets generate a sha256 and add it to the manifest.yaml
    assets_paths=$(find $pipelines_dir -mindepth 1 -maxdepth 1 -type f -name '*'|grep -v ".DS_Store")
    local assets_names
    for asset_path in ${assets_paths}
    do
        asset_name=${asset_path#$pipelines_dir/}
        echo "Asset name: $asset_name"
        assets_names="${assets_names} ${asset_name}"
        if [ -f $asset_path ] && [ "$(basename -- $asset_path)" != "manifest.yaml" ]
        then
            sha256=$(cat $asset_path | $sha256cmd | awk '{print $1}')
            echo "- file: $asset_name" >> $asset_manifest
            echo "  sha256: $sha256" >> $asset_manifest
        fi
    done

    # build archive of tekton pipelines
    COPYFILE_DISABLE=1; export COPYFILE_DISABLE #avoid hidden ._foo files on Mac
    tar -czf $assets_dir/${prefix}-pipelines.tar.gz -C $pipelines_dir ${assets_names}
    tarballSHA=$(($sha256cmd $assets_dir/${prefix}-pipelines.tar.gz) | awk '{print $1}')
    echo ${tarballSHA}> $assets_dir/${prefix}-pipelines-tar-gz-sha256
    echo "*************************************************"
    echo "Created ${prefix}-pipelines.tar.gz"
    echo ${prefix}-pipelines-tar-gz-sha256: ${tarballSHA}
    echo "*************************************************"
}

login_container_registry() {
   local container_registry_login_option="docker"
   if [[ (! -z $IMAGE_REGISTRY) && (! -z "$IMAGE_REGISTRY_USERNAME") && (! -z "$IMAGE_REGISTRY_PASSWORD") ]]; then
      if [[ ( ! -z "$USE_BUILDAH" ) && ( "$USE_BUILDAH" == true ) ]]; then
         container_registry_login_option="buildah"
      fi
      echo "[INFO] inside login_container_registry method Logging in the container registry using $container_registry_login_option "
      echo "$IMAGE_REGISTRY_PASSWORD" | $container_registry_login_option login -u $IMAGE_REGISTRY_USERNAME --password-stdin $IMAGE_REGISTRY
   fi
}

fetch_image_digest() {
   if [[ ( ! -z "$USE_BUILDAH" ) && ( "$USE_BUILDAH" == false ) ]]; then
      echo "[INFO] Fetching the image digest value for image $destination_image_url using docker inspect"
      docker pull $destination_image_url
      if [ $? != 0 ]; then
          echo "[ERROR] There is no such image with the image url = $destination_image_url hence the image could not be pulled to fetch the digest value, please verify the correct image url and try again."
          sleep 1
          exit 1
      fi
      image_digest_value_withquote=$(docker inspect --format='{{json .RepoDigests}}' $destination_image_url | jq 'values[0]');
      if [[ ( -z "$image_digest_value_withquote" ) ]]; then
         echo "[ERROR] The digest value for the image url : $destination_image_url could not be fetched using docker inspect. Please verify the image with the url exists and try again."
         sleep 1
         exit 1
      fi
      #This is to remove double quotes at the beginning and the end of the digest value found by above command
      fetched_image_digest_value=$(sed -e 's/^"//' -e 's/"$//' <<<"$image_digest_value_withquote");

      echo "[INFO] using docker inspect image_digest_value=$fetched_image_digest_value"

   elif [[ ( ! -z "$USE_BUILDAH" ) && ( "$USE_BUILDAH" == true ) ]]; then
      echo "[INFO] Fetching the image digest value for image $destination_image_url using skopeo inspect"
      image_digest_value_withquote=$( skopeo inspect docker://$destination_image_url | jq '.Digest' )
      if [[ ( -z "$image_digest_value_withquote" ) ]]; then
         echo "[ERROR] The digest value for the image url : $destination_image_url could not be fetched using skopeo inspect.Please verify the image with the url exists and try again"
         sleep 1
         exit 1
      fi
      image_digest_value=$(sed -e 's/^"//' -e 's/"$//' <<<"$image_digest_value_withquote");
      fetched_image_digest_value=$IMAGE_REGISTRY/$IMAGE_REGISTRY_ORG/$UTILS_IMAGE_NAME@$image_digest_value

      echo "[INFO] using skopeo image_digest_value=$fetched_image_digest_value"

   fi
}

set_image_replacement_string() {
   #if destination_image_url ends with latest don't pull image digest
   if [[ "$destination_image_url" != *:latest ]]; then
      fetch_image_digest
      image_replacement_string=$fetched_image_digest_value
   else
      image_replacement_string=$IMAGE_REGISTRY/$IMAGE_REGISTRY_ORG/$UTILS_IMAGE_NAME:latest
   fi
}

update_utils_image_urls() {
   #imagename in every pipeline task file that will be replaced with correct digest value.
   image_original_string="icp4apps/pipelines-utils:latest"

   set_image_replacement_string
   local image_digest_value=$image_replacement_string

   echo "[INFO] Replacing the utils container image string from 'image : $image_original_string' with 'image : $image_digest_value' in all the pipeline task yaml files";
      
   echo "[INFO] find and sed replace image_original_string=$image_original_string to  image_digest_value=$image_digest_value"
   if [[ "$OSTYPE" == "darwin"* ]]; then
      echo "[INFO] The script is running in Mac OS"
      find ./ -type f -name '*.yaml' -exec sed -i '' 's|'"$image_original_string"'|'"$image_digest_value"'|g' {} +
   else
      echo "[INFO] The script is running in unix OS"
      find ./ -type f -name '*.yaml' -exec sed -i 's|'"$image_original_string"'|'"$image_digest_value"'|g' {} +
   fi
   if [ $? == 0 ]; then
      echo "[INFO] Updated utils container image string from original 'image : $image_original_string' with 'image : $image_digest_value' in all the pipeline taks yaml files successfully"
   else
      echo "[ERROR] There was some error in updating the string from original 'image : $image_original_string' with 'image : $image_digest_value' in all the pipeline task yaml files."
      sleep 1
      exit 1
   fi
}

confirm_inputs() {
   #preparing destination image url based on given inputs
   if [[ (! -z "$IMAGE_REGISTRY") && ( ! -z "$IMAGE_REGISTRY_ORG" ) && ( ! -z "$UTILS_IMAGE_NAME" ) && ( ! -z "$UTILS_IMAGE_TAG" ) ]]; then
      echo "[INFO] Preparing destination utils image url using below variables as per given by the user"
      echo "[INFO] IMAGE_REGISTRY=$IMAGE_REGISTRY"
      echo "[INFO] IMAGE_REGISTRY_ORG=$IMAGE_REGISTRY_ORG"
      echo "[INFO] UTILS_IMAGE_NAME=$UTILS_IMAGE_NAME"
      echo "[INFO] UTILS_IMAGE_TAG=$UTILS_IMAGE_TAG"
      destination_image_url=$IMAGE_REGISTRY/$IMAGE_REGISTRY_ORG/$UTILS_IMAGE_NAME:$UTILS_IMAGE_TAG
      echo "[INFO] Concatenated destination utils image urls are as below"
      echo "[INFO] destination_image_url=$destination_image_url"
      destination_image_url_with_latest_tagname=$IMAGE_REGISTRY/$IMAGE_REGISTRY_ORG/$UTILS_IMAGE_NAME:latest
      echo "[INFO] destination_image_url_with_latest_tagname=$destination_image_url_with_latest_tagname"
   else
      echo "[ERROR] Image url cannot be formed ,one or more of the environment variables IMAGE_REGISTRY,IMAGE_REGISTRY_USERNAME, UTILS_IMAGE_NAME or UTILS_IMAGE_TAG are empty, please provide correct envrionment variables for image registry and image details for building the image and try again."
      echo "[ERROR] IMAGE_REGISTRY=$IMAGE_REGISTRY"
      echo "[ERROR] IMAGE_REGISTRY_ORG=$IMAGE_REGISTRY_ORG"
      echo "[ERROR] UTILS_IMAGE_NAME=$UTILS_IMAGE_NAME"
      echo "[ERROR] UTILS_IMAGE_TAG=$UTILS_IMAGE_TAG"
      sleep 1
      exit 1
   fi
}

publish_utils_image() {
   if [[ ( "$UTILS_IMAGE_REGISTRY_PUBLISH" == true ) ]]; then
      echo "[INFO] Publishing a new utils container image"

      confirm_inputs

      #Login to the registry if the username and password are present
      login_container_registry

      # navigating to the folder where the utils container docker file is present
      cd $base_dir/pipelines/docker/pipelines-utils/

      echo "[INFO] Building the utils container image using USE_BUILDAH=$USE_BUILDAH"
      if [[ ( ! -z "$USE_BUILDAH" ) && ( "$USE_BUILDAH" == true ) ]]; then
         buildah bud -t $destination_image_url -t $destination_image_url_with_latest_tagname .
         if [ $? == 0 ]; then
            echo "[INFO] The buildah container image $destination_image_url was build successfully"
            
            # Running actual buildah push command to push the image  to the registry using buildah.
            echo "[INFO] Pushing the image to $destination_image_url "
            buildah push $destination_image_url docker://$destination_image_url
            if [ $? == 0 ]; then
               echo "[INFO] The buildah container image $destination_image_url was successfully pushed"
               buildah push $destination_image_url_with_latest_tagname docker://$destination_image_url_with_latest_tagname
            else
               echo "[ERROR] The buildah container image push failed for this image $destination_image_url, please check the logs"
               sleep 1
               exit 1
            fi
         else
            echo "[ERROR] The buildah container image $destination_image_url build failed, please check the logs."
            sleep 1
            exit 1
         fi
      else
         echo "[INFO] Running docker build for image url : $destination_image_url"
               
         # Running actual docker build command to build the image using docker.
         docker build -t $destination_image_url -t $destination_image_url_with_latest_tagname .
         if [ $? == 0 ]; then
            echo "[INFO] Docker image $destination_image_url was build successfully"

            # Running actual docker push command to push the image  to the registry using docker.
            echo "[INFO] Pushing the image $destination_image_url "
            docker push $destination_image_url
            if [ $? == 0 ]; then
               echo "[INFO] The docker image was successfully pushed to $destination_image_url"
               docker push $destination_image_url_with_latest_tagname
            else
               echo "[ERROR] The docker push failed for this image $destination_image_url, please check the logs"
               sleep 1
               exit 1
            fi
         else
            echo "[ERROR] The docker image $destination_image_url build failed, please check the logs."
            sleep 1
            exit 1
         fi
      fi

      #navigating to the base folder
      cd $base_dir

      #calling method to update image references
      update_utils_image_urls
   else
      echo "[INFO] We are not publishing new utils container image since UTILS_IMAGE_REGISTRY_PUBLISH is not set to true "
   fi
}

OPTIONAL_ARGS=1
if [ $# -eq $OPTIONAL_ARGS ]
then
    pipelines_dir=$base_dir/pipelines/$1
    if [ ! -d $pipelines_dir ]
    then
        echo "$pipelines_dir not found"
        exit 1
    fi;
    if [[ "$1" == "docker/pipelines-utils" ]]; then
      publish_utils_image
    else
      package $pipelines_dir `basename $pipelines_dir`
    fi
    exit 0
fi;

publish_utils_image
package $eventing_pipelines_dir "events"
package $odo_pipelines_dir "odotechpreview"

echo -e "--- Created pipeline artifacts"
# expose an extension point for running after main 'package' processing
exec_hooks $script_dir/ext/post_package.d

