# Pull base image 
from tomcat:latest
# Maintainer 
LABEL MAINTAINER "pavandeepakpagadala@gmail.com"
COPY ./*.war /usr/local/tomcat/webapps/
EXPOSE 8080
CMD [“catalina.sh”, “run”]