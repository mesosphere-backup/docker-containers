# Chronos Docker Image

Parameterized on Chronos version and Mesos version

Build the Docker image for a specific Chronos and Mesos version:
````
./mk.sh <chronos-version> <mesos-version>
```

Example:
```
./mk.sh 2.4.0-0.1.20151007110204.ubuntu1404 0.25.0-0.2.70.ubuntu1404
```

This is run by an [automated build on TeamCity](https://teamcity.mesosphere.io/viewType.html?buildTypeId=Oss_Chronos_Docker_Image_Publish&tab=buildTypeStatusDiv&branch_Oss_Chronos=__all_branches__&hasCompatibleAgentsOrTypesToRun=true&branchSelectorEnabled=true&showHistoryLink=false&chartGroup=buildtype-graphs) that is triggered by newly tagged Chronos releases.
