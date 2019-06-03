FROM centos:centos7
MAINTAINER sfeuga@member.fsf.org

#########################################
##             CONSTANTS               ##
#########################################
# path for Network Licence Manager
ARG FLT_URL=https://s3.amazonaws.com/thefoundry/tools/FLT/7.3v2/
ARG FLT_FILE=FLT7.3v2-linux-x86-release-64.tgz
ARG FLU_URL=https://s3.amazonaws.com/thefoundry/tools/FLU/7.3v2/
ARG FLU_FILE=FLU_7.3v2_linux-x86-release-64RH.tgz
# path for temporary files
ARG HOME_PATH=/home/fltadmin/

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

RUN mkdir -p ${HOME_PATH} && cd ${HOME_PATH} && \
    mkdir -p FLT && cd FLT && \
    wget --progress=bar:force ${FLT_URL}${FLT_FILE} && \
    tar -zxvf ${FLT_FILE} && cd FLT* && ./install.sh &&
    cd ${HOME_PATH} && mkdir -p FLU && cd FLU && \
    wget --progress=bar:force ${FLU_URL}${FLU_FILE} && \
    tar -zxvf ${FLU_FILE} && cd FLT* && ./install.sh &&
    cd ${HOME_PATH} 

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
