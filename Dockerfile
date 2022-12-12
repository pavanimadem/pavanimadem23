# Pull base image 
from tomcat:latest
# Maintainer 
LABEL MAINTAINER "pavandeepakpagadala@gmail.com"
COPY /opt/tomcat/webapps/*.war /usr/local/tomcat/webapps/