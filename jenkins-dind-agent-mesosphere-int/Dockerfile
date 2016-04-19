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
unzip \
groff \
less

COPY wrapper.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wrapper.sh

# Install awscli and s3cmd
RUN pip install --upgrade awscli s3cmd python-magic

# Populate JDK env
ENV JAVA_HOME=/usr/lib/jvm/default-jvm
ENV PATH=${PATH}:${JAVA_HOME}/bin

# Add any SSH known hosts to the environment variable $SSH_KNOWN_HOSTS
ENV SSH_KNOWN_HOSTS github.com
RUN ssh-keyscan $SSH_KNOWN_HOSTS | tee /etc/ssh/ssh_known_hosts

ENTRYPOINT []
CMD []
