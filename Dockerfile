# Pull base image 
from amazonlinux
# Maintainer 
LABEL MAINTAINER "pavandeepakpagadala@gmail.com"
RUN yum install update -y
RUN cp -R *.war /root/