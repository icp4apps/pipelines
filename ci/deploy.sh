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
#!/bin/bash -e

. $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/env.sh

prereqs() {
    command -v oc >/dev/null 2>&1 || { echo "Unable to deploy pipelines-index: oc is not installed."; exit 1; }
}

get_route() {
    for i in 1 2 3 4 5 6 7 8 9 10; do
        ROUTE=$(oc get route pipelines-index --no-headers -o=jsonpath='{.status.ingress[0].host}')
        if [ -z "$ROUTE" ]; then
            sleep 1
        else
            echo "https://$ROUTE"
            return
        fi
    done
    echo "Unable to get route for pipelines-index"
    exit 1
}

# check needed tools are installed
prereqs

# deploy nginx container
if [ -f "$build_dir/openshift.yaml" ]; then
    echo "= Deploying pipelines index container into your cluster."
    oc apply -f "$build_dir/openshift.yaml"

    PIPELINES_INDEX_ROUTE=$(get_route)
    echo "== Your pipelines index is available at: $PIPELINES_INDEX_ROUTE/events-pipelines.tar.gz"
fi
