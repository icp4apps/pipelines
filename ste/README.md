## About this feature

- Feature Name: Pipelines

- Availability Info: 
  - kabanero pipelines 0.9.2/CP4Apps 4.2
  - Pipelines 0.22.0/CP4Apps 4.3

- Presenters
  - Michael Cheng
  - Claudia Yan

## Overview
Formerly kabanero-pipelines,
Pipelines enable a continuous integration and continuous delivery (CI/CD) workflow. Pipelines run serverless and use containers as building blocks, leveraging Kubernetes to scale and making them portable to any other Kubernetes systems.  A set of default tasks and pipelines are provided that can be associated with application stacks. 


### Value to Customer 
These pipelines leverage steps and tasks that provide the following capabilities:

    - build the application stack
    - enforce the governance policy
    - publish the image to a container registry
    - scan the published image
    - sign the image
    - retag an image
    - deploy the application to the Kubernetes cluster


## The Events Pipelines

- build-pl pipeline
- build-push-promote-pl pipeline
- build-push-promote-task pipeline
- deploy-task pipeline
- image-scane-task pipeline
- image-retag-pl pipeline


## Notable Changes from 4.2 to 4.3
Openshift Pipelines Operator v1.1

Cp4Apps V4.3 installs Openshift Pipelines Operator V1.1, which uses Tekton Pipelines 0.14.3. 
For a list of breaking changes, search for "Backwards incompatible changes" for each release at https://github.com/tektoncd/pipeline/releases. For pipelines released with Cloudpak for Applications V4.2, the following changes were made for V4.3:

- For EventListener:
  - Before:
     ```
         - bindings:
          - apiversion: v1alpha1
                name: <name>
     ```
  
  - After (works only in openshift pipelines operator v1.1 or later)
     ```
          -bindings:
             - apiversion: v1alpha1
               name: <name>
               ref: <name>
      ```
- For TriggerTemplate
  - before:
     ```
         params:
             - name: <name>
               description: <description>
               type: <type>
     ```
  - After: works in both openshift pipelines operator v1.0 and v1.1:
     ```
          params:
             - name: <name>
               description: <description>
     ```

GitOps has also been removed in 4.3



## Troubleshooting

### Pipeline run fails at the build-push step
Error: 
```
error pushing image "docker-registry.default.svc:5000/kabanero/demo:d2a049a" to "docker://docker-registry.default.svc:5000/kabanero/demo:d2a049a":
error copying layers and metadata from "containers-storage:[overlay@/var/lib/containers/storage+/var/run/containers/storage:overlay.imagestore=/var/lib/shared,
overlay.mount_program=/usr/bin/fuse-overlayfs,overlay.mountopt=nodev,metacopy=on]docker-registry.default.svc:5000/kabanero/demo:d2a049a"
to "docker://docker-registry.default.svc:5000/kabanero/demo:d2a049a":
Error trying to reuse blob sha256:48905dae401049ac43befb4f900a6aa0b5d30119db1f0cd0cca92980e0040ad0
at destination: unable to retrieve auth token: invalid username/password
```

To resolve this problem, try the following and then rerun the pipeline:

    Increase the IOPS setting of the PV backing storage device External link icon or increase the size of the backing storage.

    Scale down the image registry deployment to 1 with the following command:

### After you run a PipelineRun, the PV does not remain BOUND and the PVC remains in Terminating state

When a PipelineRun completes, the associated pods are in a Completed state. The PV claims are bound to this resource and are in Terminating state until the pods are deleted. This default behavior helps to preserve the logs for debugging. To delete the pods and PV claims associated with a PipelineRun, you must manually delete the PipelineRun. To check the status of pipeline runs, use the oc get pipelineruns command. To delete a PipelineRun, use the oc delete pipelinerun <pipelinerun_name> command.

### While using GitHub Enterprise v2.19.3, multiple PipelineRuns get run for a single commit

This is a known issue with GitHub Enterprise v2.19.3. To prevent this issue, update your GHE instance to v2.20.x.

### Error while running the building step of a pipeline

Example error:
```
{"level":"warn","ts":1568057939.538,"logger":"fallback-logger","caller":"logging/config.go:69","msg":"Fetch GitHub commit ID from kodata failed: "KO_DATA_PATH" does not exist or is empty"} {"level":"error","ts":1568057939.8545134,"logger":"fallback-logger","caller":"git/git.go:35","msg":"Error running git [fetch --depth=1 --recurse-submodules=yes origin fc7fe7fb8d87779dd5419b509dd2c91e63ba87b7]: exit status 128\nfatal: could not read Username for 'https://github.ibm.com': No such device or address\n","stacktrace":"github.com/tektoncd/pipeline/pkg/git.run\n\t/go/src/github.com/tektoncd/pipeline/pkg/git/git.go:35\ngithub.com/tektoncd/pipeline/pkg/git.Fetch\n\t/go/src/github.com/tektoncd/pipeline/pkg/git/git.go:88\nmain.main\n\t/go/src/github.com/tektoncd/pipeline/cmd/git-init/main.go:36\nruntime.main\n\t/usr/local/go/src/runtime/proc.go:198"} {"level":"error","ts":1568057940.1771348,"logger":"fallback-logger","caller":"git/git.go:35","msg":"Error running git [pull --recurse-submodules=yes origin]: exit status 1\nfatal: could not read Username for 'https://github.ibm.com': No such device or address\n","stacktrace":"github.com/tektoncd/pipeline/pkg/git.run\n\t/go/src/github.com/tektoncd/pipeline/pkg/git/git.go:35\ngithub.com/tektoncd/pipeline/pkg/git.Fetch\n\t/go/src/github.com/tektoncd/pipeline/pkg/git/git.go:91\nmain.main\n\t/go/src/github.com/tektoncd/pipeline/cmd/git-init/main.go:36\nruntime.main\n\t/usr/local/go/src/runtime/proc.go:198"} {"level":"warn","ts":1568057940.1772096,"logger":"fallback-logger","caller":"git/git.go:92","msg":"Failed to pull origin : exit status 1"} {"level":"error","ts":1568057940.1798232,"logger":"fallback-logger","caller":"git/git.go:35","msg":"Error running git [checkout fc7fe7fb8d87779dd5419b509dd2c91e63ba87b7]: exit status 128\nfatal: reference is not a tree: fc7fe7fb8d87779dd5419b509dd2c91e63ba87b7\n","stacktrace":"github.com/tektoncd/pipeline/pkg/git.run\n\t/go/src/github.com/tektoncd/pipeline/pkg/git/git.go:35\ngithub.com/tektoncd/pipeline/pkg/git.Fetch\n\t/go/src/github.com/tektoncd/pipeline/pkg/git/git.go:94\nmain.main\n\t/go/src/github.com/tektoncd/pipeline/cmd/git-init/main.go:36\nruntime.main\n\t/usr/local/go/src/runtime/proc.go:198"} {"level":"fatal","ts":1568057940.179904,"logger":"fallback-logger","caller":"git-init/main.go:37","msg":"Error fetching git repository: exit status 128","stacktrace":"main.main\n\t/go/src/github.com/tektoncd/pipeline/cmd/git-init/main.go:37\nruntime.main\n\t/usr/local/go/src/runtime/proc.go:198"}

Step failed
```
The cause of this error could be any of these reasons:

- You created a secret for GitHub, but have not patched that secret onto the service account used by the PipelineRun or TaskRun
- You have not created a secret for GitHub, but have tried to patch the relevant service account
- You have not created a secret for GitHub and have not patched the relevant service account


An error message such as fatal: could not read Username for *GitHub repository*: No such device or address message in the failing task logs indicates that there is no tekton.dev/git annotated GitHub secret in use by the ServiceAccount that launched the PipelineRun. Create one via the pipelines dashboard. The annotation will be added and the specified ServiceAccount will be patched.


## Support scope and Open Source
This is suported as part of CP4Apps. There is a public mirror of the pipelines repository:

4.3:  https://github.com/orgs/icp4apps/teams/pipelines/repositories


4.2: https://github.com/kabanero-io/kabanero-pipelines 

Resources:

Cp4Apps 4.3: https://www.ibm.com/support/knowledgecenter/SSCSJL_4.3.x/guides/working-with-pipelines/working-with-pipelines.html
 
Cp4Apps 4.2: https://kabanero.io/guides/working-with-pipelines/#kabanero-tasks-and-pipelines
