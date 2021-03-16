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
#!/bin/bash

# setup environment
. $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/env.sh

# expose an extension point for running before main 'release' processing
exec_hooks $script_dir/ext/pre_release.d

image_registry_login

if [ -f $build_dir/image_list ]
then
    while read line
    do
        if [ "$line" != "" ]
        then
            image_push $line
        fi
    done < $build_dir/image_list
fi

# expose an extension point for running after main 'release' processing
exec_hooks $script_dir/ext/post_release.d
