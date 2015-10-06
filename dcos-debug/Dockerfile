FROM fedora
RUN yum install -y perf traceroute wget curl iputils jq gdb sysstat procps htop vim emacs git findutils strace ltrace trace-cmd iftop iotop dstat git
RUN git clone --depth 1 https://github.com/brendangregg/perf-tools /media/root/opt/mesosphere/perf-tools
RUN ln -s /media/root/opt/mesosphere/ /opt/mesosphere
