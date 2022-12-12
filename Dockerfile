# Pull base image 
from tomcat:latest
# Maintainer 
LABEL MAINTAINER "pavandeepakpagadala@gmail.com"
RUN CP /var/lib/jenkins/workspace/Java_Pipeline_Application/*.war /usr/local/tomcat/webapps/