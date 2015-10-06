FROM fedora
RUN yum install -y perf traceroute wget curl iputils jq gdb sysstat procps htop vim emacs git findutils strace ltrace trace-cmd iftop iotop dstat git
RUN yum install -y maven
RUN git clone --depth 1 https://github.com/brendangregg/perf-tools /root/perf-tools
RUN git clone --depth 1 https://github.com/feldoh/guano /root/guano
RUN mvn package -f /root/guano/
RUN bash -c 'echo alias guano=\"java -jar /root/guano/target/guano-0.1a.jar\" >> /root/.bashrc'
RUN ln -s /media/root/opt/mesosphere/ /opt/mesosphere
