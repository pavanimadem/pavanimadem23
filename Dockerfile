# Pull base image 
from ubuntu:22.04
# Maintainer 
LABEL MAINTAINER "pavandeepakpagadala@gmail.com"
RUN apt-get update
RUN cp -R /var/lib/jenkins/workspace/Java_Pipeline_Application/*.war /home/ubuntu/webapp.war