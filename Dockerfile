# Pull base image 
from amazonlinux
# Maintainer 
LABEL MAINTAINER "pavandeepakpagadala@gmail.com"
RUN cp -R /var/lib/jenkins/workspace/Java_Pipeline_Application/webapp/target/*.war /root/