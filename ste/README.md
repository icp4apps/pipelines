## About this feature

- Feature Name: Pipelines

- Availability Info: 
  - kabanero pipelines 0.9.2/CP4Apps 4.2
  - Pipelines 0.22.0/CP4Apps 4.3

- Contributors 
  - Michael Cheng
  - Claudia Yan
  - Brian Sullivan

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

* GitOps has been removed in 4.3
* Minor changes to move up to the latest version of Tekton (seperate ste available)
* Changes to the pipeline:
   * removed old default pipeline that used Tekton Webhook extension that is now removed
   * Existing event based pipeline is now default
   * Added odo techpreview pipelines to the existing pipelines



## Troubleshooting

https://www.ibm.com/support/knowledgecenter/SSCSJL_4.3.x/troubleshoot-rt.html


## Support scope and Open Source
This is suported as part of CP4Apps. There is a public mirror of the pipelines repository:

4.3:  https://github.com/orgs/icp4apps/teams/pipelines/repositories


4.2: https://github.com/kabanero-io/kabanero-pipelines 

Resources:

Cp4Apps 4.3: https://www.ibm.com/support/knowledgecenter/SSCSJL_4.3.x/guides/working-with-pipelines/working-with-pipelines.html
 
Cp4Apps 4.2: https://kabanero.io/guides/working-with-pipelines/#kabanero-tasks-and-pipelines
