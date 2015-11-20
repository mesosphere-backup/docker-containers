#!/bin/bash
#start syslog daemon to enable chronos logging
#syslogd is already installed in the chronos image
syslogd
#start chronos
#this is coming from CMD[] in docker file [overwritten while running the chronos image]
"$@"
