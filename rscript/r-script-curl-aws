FROM mesosphere/rscript-curl
MAINTAINER Mesosphere, Inc. <support@mesosphere.io>
RUN apt-get update && apt-get install -y python-pip && apt-get clean && rm -rf /var/lib/apt/lists
RUN pip install awscli

