FROM centos:centos7
MAINTAINER sfeuga@member.fsf.org

#############################################
##               CONSTANTS                 ##
#############################################
# Path for Network Licence Manager
ARG FLT_URL=https://s3.amazonaws.com/thefoundry/tools/FLT/7.3v2/
ARG FLT_FILE=FLT7.3v2-linux-x86-release-64.tgz
# Path for temporary files
ARG HOME_PATH=/home/fltadmin/

#############################################
##          ENVIRONMENTAL CONFIG           ##
#############################################
# Add the flexlm commands to $PATH
ENV PATH="${PATH}:/usr/local/foundry/LicensingTools7.3/bin/RLM/"

#############################################
##           RUN INSTALL SCRIPT            ##
#############################################
COPY /files /usr/local/bin

RUN yum update -y && \
    yum install -y redhat-lsb-core wget net-tools && \
    yum clean all

RUN mkdir -p ${HOME_PATH}
WORKDIR ${HOME_PATH}

RUN wget --progress=bar:force ${FLT_URL}${FLT_FILE} && \
    tar -zxvf *.tgz && rm *.tgz

RUN mv FLT* FLT && cd FLT && \
    echo YES | /bin/sh ./install.sh

#############################################
##                VOLUMES                  ##
#############################################
VOLUME ["/opt/foundry/"]

#############################################
##              EXPOSE PORTS               ##
#############################################
# RLM Server
EXPOSE 5053
# Admin GUI
EXPOSE 4102
# ISV Server
EXPOSE 4101

#############################################
##           Do not use ROOT user          ##
#############################################
#USER fltadmin

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
