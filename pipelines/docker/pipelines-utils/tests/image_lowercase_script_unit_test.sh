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
echo "These are the unit tests cases for image_lowercase_script.sh"
echo ""
echo ""
echo "Case 1****"
inputs_params_docker_imagename="null"
inputs_params_docker_imagetag="null"
inputs_resources_docker_image_url="image-registry.openshift-image-registry.svc:5000/kabanero/kab60-java-spring-boot2:e7a1448806240f0294035097c0203caa3f"
./image_lowercase_script.sh -u $inputs_resources_docker_image_url -n "$inputs_params_docker_imagename" -t "$inputs_params_docker_imagetag"

echo ""
echo ""
echo ""
echo "case 2*****"
inputs_params_docker_imagename="kab60-java-spring-boot2"
inputs_params_docker_imagetag="e7a1448806240f0294035097c0203caa3f"
inputs_resources_docker_image_url="image-registry.openshift-image-registry.svc:5000/kabanero"
./image_lowercase_script.sh -u $inputs_resources_docker_image_url -n "$inputs_params_docker_imagename" -t "$inputs_params_docker_imagetag"

echo ""
echo ""
echo ""
echo "case 3*****"
inputs_params_docker_imagename="null"
inputs_params_docker_imagetag="null"
inputs_resources_docker_image_url="image-registry.openshift-image-registry.svc:5000/kabanero/"
./image_lowercase_script.sh -u $inputs_resources_docker_image_url -n "$inputs_params_docker_imagename" -t "$inputs_params_docker_imagetag"

echo ""
echo ""
echo ""
echo "case 4*****"
inputs_params_docker_imagename="kab60-java-spring-boot2"
inputs_params_docker_imagetag="e7a1448806240f0294035097c0203caa3f"
inputs_resources_docker_image_url="image-registry.openshift-image-registry.svc:5000/kabanero/"
./image_lowercase_script.sh -u $inputs_resources_docker_image_url -n "$inputs_params_docker_imagename" -t "$inputs_params_docker_imagetag"
echo ""
echo ""
echo ""

echo "case 5*****"
inputs_params_docker_imagename=""
inputs_params_docker_imagetag=""
inputs_resources_docker_image_url="image-registry.openshift-image-registry.svc:5000/kabanero/kab60-java-spring-boot2:e7a1448806240f0294035097c0203caa3f"
./image_lowercase_script.sh -u $inputs_resources_docker_image_url -n "$inputs_params_docker_imagename" -t "$inputs_params_docker_imagetag"
echo ""
echo ""
echo ""

echo "case 6*****"
inputs_params_docker_imagename="kab60-java-spring-boot2"
inputs_params_docker_imagetag="e7a1448806240f0294035097c0203caa3f"
inputs_resources_docker_image_url=""
./image_lowercase_script.sh -u "$inputs_resources_docker_image_url" -n "$inputs_params_docker_imagename" -t "$inputs_params_docker_imagetag"

echo ""
echo ""
echo ""

echo "case 7*****"
inputs_params_docker_imagename=""
inputs_params_docker_imagetag=""
inputs_resources_docker_image_url="image-registry.openshift-image-registry.svc:5000/kabanero"
./image_lowercase_script.sh -u "$inputs_resources_docker_image_url" -n "$inputs_params_docker_imagename" -t "$inputs_params_docker_imagetag"

echo ""
echo ""
echo ""

echo "case 8*****"
inputs_params_docker_imagename="kab60-java-spring-boot2"
inputs_params_docker_imagetag="e7a1448806240f0294035097c0203caa3f"
inputs_resources_docker_image_url="image-registry.openshift-image-registry.svc:5000/kabanero/image2:latest"
./image_lowercase_script.sh -u "$inputs_resources_docker_image_url" -n "$inputs_params_docker_imagename" -t "$inputs_params_docker_imagetag"
