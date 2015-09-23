Steps to build a Spark docker image with Mesos dependencies:

1. Build Spark distribution artifacts
./make-distribution.sh -Phadoop-2.4

2. Copy all files in this folder into the dist folder
cp mesos_docker/* dist

3. Build the docker image in the dist folder

cd dist && TAG=1.4.1-hdfs docker build -t mesosphere/spark:$TAG .
