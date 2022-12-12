# Pull base image 
from tomcat:latest
# Maintainer 
LABEL MAINTAINER "pavandeepakpagadala@gmail.com"
COPY ./*.war /usr/local/tomcat/webapps/
EXPOSE 8082
CMD [“catalina.sh”, “run”]