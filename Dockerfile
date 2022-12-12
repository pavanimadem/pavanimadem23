# Pull base image 
from ubuntu:22.04
# Maintainer 
LABEL MAINTAINER "pavandeepakpagadala@gmail.com"
RUN apt-get update
RUN cp -R *.war /home/ubuntu/