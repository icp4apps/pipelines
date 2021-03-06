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
#!/bin/sh
# This script will build 'pipelines-utils' docker image with given image tagname and based on the dockerhub credentials given to it. The script will
# push the image to the approprite registry. Also along with the image tagname the image will be marked as 'latest' tag and pushed to the dockerhub as well.

display_help() {
 echo "$HELP **************************************************************************************************************************************************************"
 echo "$HELP 'build_utils.sh' script usage"
 echo "$HELP"
 echo "$HELP ./build_utils.sh -u <dockerhub userid> -t <pipelines-utils image tagname>"
 echo "$HELP **************************************************************************************************************************************************************"
 exit 1
}

#Tracings
INFO="[INFO]"
HELP="[HELP]"
ERROR="[ERROR]"
WARNING="[WARNING]"

while getopts ":hu:t:" opt; do
  case $opt in	
    h)
     display_help
     ;;
    u)
      dockerhubUserid=$OPTARG
      ;;
    t)
      imagetag=$OPTARG
      ;;
    \?)
      echo "$ERROR Invalid option: -$OPTARG" >&2
      display_help
      exit 1
      ;;
    :)
      echo "$ERROR Option -$OPTARG requires an argument." >&2
      display_help
      exit 1
      ;;
    *)
      display_help
      ;;
  esac
done

if [[ (-z $dockerhubUserid) || (-z $imagetag) ]]
then
  echo "$INFO dockerhubUserid=$dockerhubUserid"
  echo "$INFO imagetag=$imagetag"
  echo "$ERROR The script expects 2 input parameters and it cannot have empty values, please check the usage instructions below and try again with correct inputs."
  display_help
  exit 1
fi

image_name="pipelines-utils"
latest_tag="latest"

echo "$INFO Logging in dockerhub with userid $dockerhubUserid"
echo "$INFO Please enter the password"
docker login -u $dockerhubUserid

if [ $? != 0 ]; then
   echo "$ERROR Some error in logging into dockerhub for userid $dockerhubUserid.  Please check the userid and password and try again."
   exit 1
fi

echo "$INFO logged in successfully in dockerhub for userid '$dockerhubUserid'"
echo "$INFO Building the image with tags '$dockerhubUserid/$image_name:$imagetag' and '$dockerhubUserid/$image_name:$latest_tag'"
echo "$INFO"
docker build -t $dockerhubUserid/$image_name:$imagetag -t $dockerhubUserid/$image_name:$latest_tag .
if [ $? != 0 ]; then
   echo "$ERROR Some error in building the image $image_name from Dockerfile.  Please check the error and after updating the issue in Dockerfile try again later"
   exit 1
else
   echo "$INFO"
   echo "$INFO The image $image_name built successfully with tags '$dockerhubUserid/$image_name:$imagetag' and '$dockerhubUserid/$image_name:$latest_tag' "
fi

echo "$INFO Pushing the image '$dockerhubUserid/$image_name:$imagetag' and '$dockerhubUserid/$image_name:$latest_tag' to the dockerhub of userid $dockerhubUserid"
docker push $dockerhubUserid/$image_name:$imagetag
docker push $dockerhubUserid/$image_name:$latest_tag
if [ $? != 0 ]; then
   echo "$ERROR Some error in pushing the image with tags '$dockerhubUserid/$image_name:$imagetag' or '$dockerhubUserid/$image_name:$latest_tag'."
   exit 1
else
   echo "$INFO"
   echo "$INFO The image $image_name was successfully pushed to dockerhub with tags '$dockerhubUserid/$image_name:$imagetag' and '$dockerhubUserid/$image_name:$latest_tag' "
fi
