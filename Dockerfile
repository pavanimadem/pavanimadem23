# Pull base image 
from tomcat:latest
# Maintainer 
LABEL MAINTAINER "pavandeepakpagadala@gmail.com"
COPY /var/lib/jenkins/workspace/Java_Pipeline_Application/webapp/target*.war /usr/local/tomcat/webapps/