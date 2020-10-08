# Table Of Contents

- [Pipelines](#Pipelines)
- [Odo Tech Preview](#Odo-Tech-Preview)

# Pipelines

We use [pipelines](https://github.com/tektoncd/pipeline/tree/master/docs#usage) to illustrate a continuous input and continuous delivery (CI/CD) workflow. This repository provides a set of default tasks and pipelines that can be associated with application stacks. These pipelines validate the application stack is active, build the application stack, publish the image to a container registry, scan the published image, and then deploy the application to a cluster. You can also create your own tasks and pipelines and customize the pre-built pipelines and tasks. All tasks and pipelines are activated by a standard Kubernetes operator.

To learn more about the tasks and pipelines and how to run the pipelines, please visit the [working with pipelines guide](https://kabanero.io/guides/working-with-pipelines/).


# Odo Tech Preview

Starting with github repositories containing odo projects, odo tech preview enables you to build and deploy odo projects using Openshift Pipelines. Currently, only the following odo devfiles are enabled:
- nodejs
- java-openliberty

For more information about developer experience using odo, see "Link to odo developer experience in KC".


## Activating Odo Stacks

Only nodejs and java-openliberty stacks are enabled. 
To activate the nodejs stack, create a file named `nodejs-odo-stack.yaml` with the following contents:

```
apiVersion: kabanero.io/v1alpha2
kind: Stack
metadata:
  name: nodejs-odo
  namespace: kabanero
spec:
  name: nodejs-odo
  versions:
  - desiredState: active
    pipelines:
    - gitRelease: {}
      https:
        url: https://github.com/icp4apps/pipelines/releases/download/0.20.0-rc.2/odotechpreview-pipelines.tar.gz
      id: default
      sha256: fec28d848a1a60faadcaf22f2f37799a7a94cb3c13ef140981476dbfbf85a4eb
    devfile: https://raw.githubusercontent.com/odo-devfiles/registry/master/devfiles/nodejs/devfile.yaml
    metafile: https://raw.githubusercontent.com/odo-devfiles/registry/master/devfiles/nodejs/meta.yaml
```

followed by:

```
oc apply -f nodejs-odo-stack.yaml
```

To activate the java-openliberty stack, create a file `openlibertay-odo-stack.yaml` with the followed contents:

```
apiVersion: kabanero.io/v1alpha2
kind: Stack
metadata:
  name: java-openliberty-odo
  namespace: kabanero
spec:
  name: java-openliberty-odo
  versions:
  - desiredState: active
    pipelines:
    - gitRelease: {}
      https:
        url: https://github.com/icp4apps/pipelines/releases/download/0.20.0-rc.2/odotechpreview-pipelines.tar.gz
      id: default
      sha256: fec28d848a1a60faadcaf22f2f37799a7a94cb3c13ef140981476dbfbf85a4eb
    devfile: https://raw.githubusercontent.com/odo-devfiles/registry/master/devfiles/java-openliberty/devfile.yaml
    metafile: https://raw.githubusercontent.com/odo-devfiles/registry/master/devfiles/java-openliberty/meta.yaml
```

followed by

```
oc apply -f openliberty-odo-stack.yaml
```

Note that:
- the pipeline URL points to an early release of the odo tech preview pipeline. For the latest release, check https://github.com/icp4apps/pipelines/releases.
- The devfile points to a devfile in the community devfile registry. You may create your own registry using the instructions provided at https://github.com/odo-devfiles/registry
- The metafile points to the metafile that corresponds to the devfile.

## Stack governance

Stack governance enables the enterprise architect to govern which stacks are active. 
Pipelines are not triggered unless the devfile in an applicaiton's repository passses the governance rules.
Upon receiving an incoming webhook, the events mediator performs the following governance check:

- Fetches the devfile in the application's repository to get the devfile's name and version. For example,
  ```
  schemaVersion: 2.0.0
  metadata:
  name: nodejs
  version: 1.0.0
  ```
- Attempts to locate an active stack whose devfile URL points to a devfile with exactly the same name and version.
- Pipeline is not triggered unless an exact match is found.

Note that:

- The devfile pointed by the active stack may or may not be the same devfile stored in the application's repository.
- The devfile pointed by the active stack is always the version that the enterprise architect designated to be used for build and deploy.
- If the name or version in the devfile is modified in the application's repository, the application won't be built unless it matches another activte stack.

## Webhook Setup

The same webhook set up to trigger Appsody pipelines also triggers odo tech preview pipelines. See "link to event based webhook setup in KC". If you have already configured an organizational level webhook on Github, it will also trigger odo tech preview pipelines automatically without change.

## Appsody vs Odo only mode

After installing Cloud Pak for Applications, you are in Appsody mode. In this mode, both Appsody and odo stacks may co-exist.  You may optionally run in odo only mode, which only allows odo stacks to be active. Appsody stacks are automatically disabled in this mode. To enable the optional odo only mode, use the following kabanero resource 

```
apiVersion: kabanero.io/v1alpha2
kind: Kabanero
metadata:
  name: kabanero
  namespace: kabanero
spec:
  version: "0.20.0"
```

## Pipeline Details

TBD: details of Pull Request and Push pipelines.
