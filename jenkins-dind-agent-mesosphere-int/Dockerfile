FROM docker:1.10-dind

# Please keep each package list in alphabetical order
# Required dependencies for the Jenkins agent
RUN apk --update add \
bash \
ca-certificates \
openjdk8 \
openssh-client

# Optional convenience functions used by most builds
RUN apk --update add \
git \
jq \
perl \
python \
python3 \
py-setuptools \
py-pip \
unzip

COPY wrapper.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wrapper.sh

# Install python-magic for mime-type detection by s3cmd
RUN pip install python-magic

# Install s3cmd tool
RUN git clone https://github.com/s3tools/s3cmd.git /tmp/s3cmd && cd /tmp/s3cmd && python setup.py install && rm -rf /var/cache/apk/* /tmp/s3cmd

# Populate JDK env
ENV JAVA_HOME=/usr/lib/jvm/default-jvm
ENV PATH=${PATH}:${JAVA_HOME}/bin

# Add any SSH known hosts to the environment variable $SSH_KNOWN_HOSTS
ENV SSH_KNOWN_HOSTS github.com
RUN ssh-keyscan $SSH_KNOWN_HOSTS | tee /etc/ssh/ssh_known_hosts

ENTRYPOINT []
CMD []
