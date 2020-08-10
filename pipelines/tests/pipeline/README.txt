These are the instructions to install the ICPA pipelines repo test Tekton pipeline, including the eventing setup.

Openshift cluster setup
-----------------------

1. Obtain an Openshift cluster and install ICPA, which includes the team operator.   The github webhook needs to be registered to call this cluster, which will be covered later.  However, if we reuse
   some set cluster names, then it will keep you from needing to create new webhooks in github.  I suggest "pipelines",  "pipelines2". I think
   we only really need the latest version (version n) of the ICPA Operator, and version n-1 clusters running to be safe.  

2. git clone git@github.ibm.com:IBMCloudPak4Apps/pipelines.git either on your local machine, if you access your cluster with a remote oc login, or directly to your
  cluster machine if you ssh and run commands that way. 
  
3. Edit pipelines/tests/pipeline/eventmediator.yaml and change the value of "body.webhooks-tekton-monitor-dashboard-url" to your cluster env URL.

4. From pipelines/tests/pipeline  and then oc apply all the yaml files

5. Edit pipelines/pipelines/sample-helper-files/storage-samples/nfs-pv.yaml with the ip address of the Openshift cluster, and apply it, you can use this command:
    find . -type f -name '*.yaml' -exec oc apply -f  {} \;
    
6. Run the pipelines/tests/pipeline/pv.sh script

7. Create a "ghe-https-secret" in the "kabanero" namespace with a personal access token (or application OAuth) for github, which the eventing infrastructure will use. This means github will be
  accessed to pull (even when its a public repo) with a token and also to push the test results back to the PR that triggered the build. Also associate this with the "kabanero-pipeline-test" 
  service account. Set the correct annotations for the github that you are accessing. 

8. Distribute the OpenShift console login credentials to the team members so they may access the OpenShift console in the event they need to look at a build failure, which is linked
  from the PR.

Github webhook setup
--------------------
	
If you need to create a new webhook or update a webhook:

1. Payload URL :  https://<URL to Openshift cluster>/webhook  
2. Contest Type:  application/json
3. Secret: empty / black / null
4. SSL Verfication:  Disabled
5. Which Events:  Just PRs.  I didn't yet try to net this down, and selected ALL, which won't hurt
6. Active:  checked
