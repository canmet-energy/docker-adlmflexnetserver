FROM centos:centos7
MAINTAINER sfeuga@member.fsf.org

#########################################
##             CONSTANTS               ##
#########################################
# path for Network Licence Manager
ARG FLT_URL=https://s3.amazonaws.com/thefoundry/tools/FLT/7.3v2/
ARG FLT_FILE=FLT7.3v2-linux-x86-release-64.tgz
# path for temporary files
ARG TEMP_PATH=/tmp/FLT

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################
# add the flexlm commands to $PATH
ENV PATH="${PATH}:/opt/flexnetserver/"

#########################################
##         RUN INSTALL SCRIPT          ##
#########################################
ADD /files /usr/local/bin

RUN yum update -y && yum install -y \
    redhat-lsb-core \
    wget && \
    yum clean all

RUN mkdir -p ${TEMP_PATH} && cd ${TEMP_PATH} && \
    wget --progress=bar:force ${FLT_URL}${FLT_FILE} && \
    tar -zxvf ${FLT_FILE} && cd FLT* && ./install.sh &&
    cd && rm -rf ${TEMP_PATH}

# fltadmin is required for -2 -p flag support
RUN groupadd -r fltadmin && \
    useradd -r -g fltadmin fltadmin

#########################################
##              VOLUMES                ##
#########################################
VOLUME ["/var/flexlm"]

#########################################
##            EXPOSE PORTS             ##
#########################################
EXPOSE 2080
EXPOSE 27000-27009

# do not use ROOT user
USER fltadmin

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# no CMD, use container as if 'lmgrd'
