#!/bin/sh
# Get the relevant python code from monitor-task.yaml
sed  -e '1,/#CODE_TO_UNIT_TEST_STARTS_HERE/ d' -e '1,/#CODE_TO_UNIT_TEST_ENDS_HERE/ s/      //' -e '/#CODE_TO_UNIT_TEST_ENDS_HERE/,/EOF/ d'< ../../incubator/events/monitor-task.yaml > monitortask.py
# run unit test
python monitortask_test.py
