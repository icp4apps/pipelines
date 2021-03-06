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



echo
echo "Installing test prereqs ..."
echo
# We are going to use the kabanero-utils image for running our tests
# so we need to install anything we need that is missing from this image
yum -y install findutils
echo
echo "... finished installing test prereqs"
echo


. ./env.sh
echo "[INFO] utility_script_enforce_stack_policy_path=$utility_script_enforce_stack_policy_path"
echo "[INFO] utility_script_enforce_deploy_stack_policy_path=$utility_script_enforce_deploy_stack_policy_path"
# Time to run tests now
scriptHome=$(dirname $(readlink -f $0))
level=$(date "+%Y-%m-%d_%H%M%S")
buildPath=$scriptHome/build_${level}
# cd $scriptHome/tests

mkdir -p $buildPath
ln -fsvn $buildPath $scriptHome/build

let anyfail=0
failed=""

regressionTestScripts=$(find . -type f -name '[0-9]*.sh' | sort)
for testcase in $( echo "$regressionTestScripts") ; do
   if [ -f "$testcase" ] ; then
     testsuiteName=$(basename $(dirname $testcase))
     testcaseScript=$(basename "$testcase")
     testcaseName=${testcaseScript%.*}
     testcasePath=$buildPath/$testsuiteName/$testcaseName
     outputPath=$testcasePath/output
     resultsPath=$testcasePath/results
     mkdir -p $outputPath
     mkdir -p $resultsPath
     echo
     echo "***********************************************"
     echo "*** Running testcase $testcase"
     echo "***********************************************"
     echo
     cd $(dirname "$testcase") 
     if [[ $testcase == *.sh ]] ; then
       chmod 755 ./$testcaseScript
       ./$testcaseScript > >(tee -a $resultsPath/${testcaseScript}.stdout.txt) 2> >(tee -a $resultsPath/${testcaseScript}.stderr.txt >&2)
       if [ $? -ne 0 ]; then
         let anyfail+=1
         failed="$failed $testcase"
         touch $testcasePath/FAILED.TXT
       else
         touch $testcasePath/PASSED.TXT
       fi

     fi
     if [[ $testcase == *.yaml ]] || [[ $testcase == *.yml ]] ; then
       ansible-playbook $testcaseScript  > >(tee -a $resultsPath/${testcaseScript}.stdout.txt) 2> >(tee -a $resultsPath/${testcaseScript}.stderr.txt >&2)
       if [ $? -ne 0 ]; then
         let anyfail+=1
         failed="$failed $testcase"
         touch $testcasePath/FAILED.TXT
       else
         touch $testcasePath/PASSED.TXT
       fi
     fi
     echo
     echo "***********************************************"
     echo "*** Finished running testcase $testcase"
     echo "***********************************************"
     echo
     cd -
   else
     echo
     echo "*** No test found in $testcase"
     echo
   fi
done

# Summarize results
if [ $anyfail -eq 0 ] ; then
   echo "*** All testcases ran without error"
else
   echo "*** There were $anyfail testcase failures - $failed"
fi 

exit $anyfail
