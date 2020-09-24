import monitortask

aSucceeded = { "metadata": { "namespace": "ns1", "name": "name1" } ,
      "spec": { "pipelineRef": { "name": "pipelinea" } },
      "status": {  "conditions": [ { "status": u"True", "type": "Succeeded" }] }}
aPending = { "metadata": { "namespace": "ns1", "name": "name1" } ,
      "spec": { "pipelineRef": { "name": "pipelinea" } },
      "status": {  "conditions": [ { "status": u"True", "type": "Unknown" }] }}
aFailed = { "metadata": { "namespace": "ns1", "name": "name1" } ,
      "spec": { "pipelineRef": { "name": "pipelinea" } },
      "status": {  "conditions": [ { "status": u"False", "type": "Succeeded" }] }}
bFailed = { "metadata": { "namespace": "ns2", "name": "name2" } ,
      "spec": { "pipelineRef": { "name": "pipelineb" } },
      "status": {  "conditions": [ { "status": u"False",  "type": "Succeeded" }] }}
bPending = { "metadata": { "namespace": "ns2", "name": "name2" } ,
      "spec": { "pipelineRef": { "name": "pipelineb" } },
      "status": {  "conditions": [ { "status": u"False",  "type": "Unknown" }] }}
bSucceeded = { "metadata": { "namespace": "ns2", "name": "name2" } ,
      "spec": { "pipelineRef": { "name": "pipelineb" } },
      "status": {  "conditions": [ { "status": u"True",  "type": "Succeeded" }] }}
cSucceeded = { "metadata": { "namespace": "ns3", "name": "name3" } ,
      "spec": { "pipelineRef": { "name": "pipelinec" } },
      "status": {  "conditions": [ { "status": u"True", "type": "Succeeded" }] }}
cFailed = { "metadata": { "namespace": "ns3", "name": "name3" } ,
      "spec": { "pipelineRef": { "name": "pipelinec" } },
      "status": {  "conditions": [ { "status": u"False", "type": "Succeeded" }] }}
cPending = { "metadata": { "namespace": "ns3", "name": "name3" } ,
      "spec": { "pipelineRef": { "name": "pipelinec" } },
      "status": {  "conditions": [ { "status": u"False", "type": "Unknown" }] }}

dSucceeded = { "metadata": { "namespace": "ns4", "name": "name4" } ,
      "spec": { "pipelineRef": { "name": "pipelined" } },
      "status": {  "conditions": [ { "status": u"True", "type": "Succeeded" }] }}
              
def testGetKey():
  aKey = monitortask.getKey(aSucceeded)
  if aKey != "ns1/name1":
    print "testGetKey failed for" , aSucceeded
    exit(1)
  bKey = monitortask.getKey(bFailed)
  if bKey != "ns2/name2":
    print "testGetKey failed for" , bFailed
    exit(1)
def testGetStatus():
  aStatus = monitortask.getStatus(aSucceeded)
  if aStatus != monitortask.STATUS_SUCCEEDED:
    print "testGetSTatus failed for" , aSucceeded
    exit(1)
  bStatus = monitortask.getStatus(bFailed)
  if bStatus != monitortask.STATUS_FAILED:
    print "testGetStatus failed for" , bFailed
    exit(1)
  cStatus = monitortask.getStatus(cPending)
  if cStatus != monitortask.STATUS_PENDING:
    print "testGetStatus failed for" , cPending
    exit(1)
def testCreateResourceMap():
  resourceList = [aSucceeded, bFailed, cPending]
  resourceMap = monitortask.createResourceMap(resourceList)
  if resourceMap[monitortask.getKey(resourceList[0])][monitortask.STATUS] != monitortask.STATUS_SUCCEEDED:
    print "testCreateResourceMap failed for ", resourceList[0]
    exit(1)
  if resourceMap[monitortask.getKey(resourceList[1])][monitortask.STATUS] != monitortask.STATUS_FAILED:
    print "testCreateResourceMap failed for ", resoruceList[1]
    exit(1)
  if resourceMap[monitortask.getKey(resourceList[2])][monitortask.STATUS] != monitortask.STATUS_PENDING:
    print "testCreateResourceMap failed for ", resourceList[2]
    exit(1)
def testUpdateResourceMap():
  existingStatus = {}
  resourceList = []
  newStatus = monitortask.createResourceMap(resourceList)
  numPending = monitortask.updateResourceMap(newStatus, existingStatus)
  if numPending != 0 or len(existingStatus) != 0:
    print "testUpdateResourceMap failed", resourceList, existingStatus
    exit(1)

  resourceList = [aPending ]
  newStatus = monitortask.createResourceMap(resourceList)
  numPending = monitortask.updateResourceMap(newStatus, existingStatus)
  if numPending != 1 or len(existingStatus) != 1:
    print "testUpdateResourceMap failed", resourceList, existingStatus
    exit(1)

  resourceList = [aPending, bPending ]
  newStatus = monitortask.createResourceMap(resourceList)
  numPending = monitortask.updateResourceMap(newStatus, existingStatus)
  if numPending != 2 or len(existingStatus) != 2:
    print "testUpdateResourceMap failed", resourceList, existingStatus
    exit(1)

  resourceList = [aSucceeded, bPending, cPending ]
  newStatus = monitortask.createResourceMap(resourceList)
  numPending = monitortask.updateResourceMap(newStatus, existingStatus)
  if numPending != 2 or len(existingStatus) != 3:
    print "testUpdateResourceMap failed", resourceList, existingStatus
    exit(1)

  resourceList = [aSucceeded, bFailed, cPending ]
  newStatus = monitortask.createResourceMap(resourceList)
  numPending = monitortask.updateResourceMap(newStatus, existingStatus)
  if numPending != 1 or len(existingStatus) != 3:
    print "testUpdateResourceMap failed", resourceList, existingStatus
    exit(1)

  resourceList = [aSucceeded, bFailed, cSucceeded ]
  newStatus = monitortask.createResourceMap(resourceList)
  numPending = monitortask.updateResourceMap(newStatus, existingStatus)
  if numPending != 0 or len(existingStatus) != 3:
    print "testUpdateResourceMap failed", resourceList, existingStatus
    exit(1)

  resourceList = [bFailed, cSucceeded ]
  newStatus = monitortask.createResourceMap(resourceList)
  numPending = monitortask.updateResourceMap(newStatus, existingStatus)
  if numPending != 0 or len(existingStatus) != 3:
    print "testUpdateResourceMap failed", resourceList, existingStatus
    exit(1)
  if existingStatus[monitortask.getKey(aSucceeded)][monitortask.STATUS] != monitortask.STATUS_MISSING:
    print "testUpdateResourceMap failed", resourceList, existingStatus
    exit(1)
  # print existingStatus

def testPostProcess():
  existingStatus = {} 
  resourceList = [aSucceeded, bFailed, cPending, dSucceeded]
  newStatus = monitortask.createResourceMap(resourceList)
  monitortask.updateResourceMap(newStatus, existingStatus)

  resourceList = [aSucceeded, bFailed, cPending ]
  newStatus = monitortask.createResourceMap(resourceList)
  monitortask.updateResourceMap(newStatus, existingStatus)

  results, failed, missing, timedout = monitortask.postProcess("https://myurl.com", existingStatus)
  if len(results) != 4 or failed != 1 or missing != 1 or timedout != 1:
    print "existing status:", existingStatus
    print "postprocess results:", results, "failed:", failed, "missing:", missing, "timedout:", timedout
    print("testPostProcess failed")
    exit(1)

testGetKey()
testGetStatus()
testCreateResourceMap()
testUpdateResourceMap()
testPostProcess()
print "All tests passed"
