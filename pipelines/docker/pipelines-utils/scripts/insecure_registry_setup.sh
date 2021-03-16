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
# This script is fetching the values of 'registries.insecure' from the 'image.config.openshift.io/cluster' resource
# that will be used by the tasks for setting the
# 'registries.insecure' in '/etc/containers/registries.conf' file of each step container in the pipelines.
# Reference Redhat documentation link : https://docs.openshift.com/container-platform/4.2/openshift_images/image-configuration.html
        
internal_registry_internal_url=$(kubectl get image.config.openshift.io/cluster -o yaml --output="jsonpath={.status.internalRegistryHostname}")
insecure_registries_string=$(kubectl get image.config.openshift.io/cluster -o yaml --output="jsonpath={.spec.registrySources.insecureRegistries[*]}")
        
if [[ ! -z "$insecure_registries_string" ]]; then
   echo "The insecure image registry list found"

   IFS=' ' # space is set as delimiter
   read -ra ADDR <<< ''"$insecure_registries_string"'' # str is read into an array as tokens separated by IFS
   for i in ''"${ADDR[@]}"''; do # access each element of array
      if [[ ! -z ''"$INSECURE_REGISTRTY"'' ]]; then
         INSECURE_REGISTRTY=''"$INSECURE_REGISTRTY"', '"'"''"$i"''"'"''
      else
         INSECURE_REGISTRTY=''"'"''"$i"''"'"''
      fi
   done
              
   if [[ (! -z "internal_registry_internal_url" ) && ( "$INSECURE_REGISTRTY" != *"$internal_registry_internal_url"* ) ]]; then
      INSECURE_REGISTRTY=''"$INSECURE_REGISTRTY"', '"'"''"$internal_registry_internal_url"''"'"''
   fi
else
   if [[ ! -z "internal_registry_internal_url" ]]; then
      INSECURE_REGISTRTY=''"'"''"$internal_registry_internal_url"''"'"''
   fi
fi
           
#example original string :
#[registries.insecure]
#registries = []
ORIGINAL_STRING='\[registries\.insecure\]\nregistries = \[\]'
           
#example replace string
#[registries.insecure]
#registries = ['pqr.com', 'abc.com']
REPLACE_STRING='\[registries\.insecure\]\nregistries = \['"$INSECURE_REGISTRTY"'\]'
           
sed -i -e ':a;N;$!ba;s|'"$ORIGINAL_STRING"'|'"$REPLACE_STRING"'|' /etc/containers/registries.conf
