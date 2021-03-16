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
# Get the relevant python code from monitor-task.yaml
sed  -e '1,/#CODE_TO_UNIT_TEST_STARTS_HERE/ d' -e '1,/#CODE_TO_UNIT_TEST_ENDS_HERE/ s/      //' -e '/#CODE_TO_UNIT_TEST_ENDS_HERE/,/EOF/ d'< ../../incubator/events/monitor-task.yaml > monitortask.py
# run unit test
python monitortask_test.py
