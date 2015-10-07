FROM fedora
RUN yum install -y perf traceroute wget curl iputils jq gdb sysstat procps htop vim emacs git findutils strace ltrace trace-cmd iftop iotop dstat git maven tcpdump mtr
RUN git clone --depth 1 https://github.com/brendangregg/perf-tools /root/perf-tools
RUN git clone --depth 1 https://github.com/feldoh/guano /root/guano
RUN git clone --depth 1 https://github.com/brendangregg/FlameGraph /root/FlameGraph
RUN mvn package -f /root/guano/
RUN find /root/perf-tools/** -executable -type f -exec cp {} /usr/local/bin/ \;
RUN bash -c 'echo alias guano=\"java -jar /root/guano/target/guano-0.1a.jar\" >> /root/.bashrc'
RUN bash -c 'echo mount -t debugfs nodev /sys/kernel/debug >> /root/.bashrc'
RUN ln -s /media/root/opt/mesosphere/ /opt/mesosphere
ADD performance-guide.txt /root/
