These are the instructions to install the kabanero-pipelines repo test pipeline, including the eventing setup

prereq
------
1. TODO - doc icpa Fyre env




1. Obtain a Fyre cluster and install the Kabanero Operator.   The github webhook needs to be registered to call this Fyre cluster, which will be covered later.  However, if we reuse
   some set cluster names (you can manually enter it in Fyre), then it will keep you from needing to create new webhooks in github.  I suggest "pipelines",  "pipelines2". I think
   we only really need the latest version (version n) of the ICPA Operator, and version n-1 clusters running to be safe.  

2.  git clone git@github.ibm.com:IBMCloudPak4Apps/pipelines.git either on your local machine, if you acccess Frye with a remote oc login, or directly to your
  Fyre machine if you ssh and run commands that way 
  
3. Edit pipelines/tests/pipeline/eventmediator.yaml and change the value of "body.webhooks-tekton-monitor-dashboard-url" to your Fyre env URL, replace "hobe" with the name of your Fyre env.

4.  From pipelines/tests/pipeline  and then oc apply all the yaml files

5. Edit pipelines/pipelines/sample-helper-files/storage-samples/nfs-pv.yaml with the ip address of the Fyre cluster, and apply it, you can use this command:
    find . -type f -name '*.yaml' -exec oc apply -f  {} \;
    
6. Run the pipelines/tests/pipeline/pv.sh script

7. Create a ghe-https-secret in the "kabanero" namespace with a personal access token for the github the eventing infrastructure will use. This means github will be
accessed to pull (even when its a public repo)  and also to upload test results. 

8.  One remaining issue is how to distribute the Open Shift kubeadmin password so that people can view their test result details if they need to. 


---------

Github webhook setup

	
If you need to create a new webhook or update a webhook:

1. Payload URL :  https://webhook-kabanero.apps.<your fyre cluster id>.os.fyre.ibm.com/webhook  
2. Contest Type:  application/json
3. Secret: empty / black / null
4. SSL Verfication:  Disabled
5. Which Events:  Just PRs.  I didn't yet try to net this down, and selected ALL, which won't hurt
6. Active:  checked
