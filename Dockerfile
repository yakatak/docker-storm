# apache-storm-0.9.3
#
# VERSION      1.0

# use the ubuntu base image provided by dotCloud
FROM ubuntu:14.04
MAINTAINER Xabier Eizmendi, xabier_yakatak.com

RUN apt-get update
RUN apt-get upgrade -y

# Install Oracle JDK 8 and others useful packages
RUN apt-get install -y python-software-properties software-properties-common
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update

# Accept the Oracle license before the installation
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections 
RUN apt-get install -y oracle-java8-installer
RUN apt-get update

# Tells Supervisor to run interactively rather than daemonize
RUN apt-get install -y wget tar 

ENV STORM_VERSION 0.9.3

ENV STORM_HOME /opt/apache-storm

# Download and Install Apache Storm
RUN wget http://apache.mirrors.ovh.net/ftp.apache.org/dist/storm/apache-storm-$STORM_VERSION/apache-storm-$STORM_VERSION.tar.gz && \
tar -xzvf apache-storm-$STORM_VERSION.tar.gz -C /opt && mv $STORM_HOME-$STORM_VERSION $STORM_HOME && \
rm -rf apache-storm-$STORM_VERSION.tar.gz

RUN mkdir -p $STORM_HOME/storm_local
ADD conf/cluster.xml $STORM_HOME/logback/cluster.xml
ADD conf/storm.yaml.template $STORM_HOME/conf/storm.yaml.template
ADD conf/logging.properties $STORM_HOME/conf/logging.properties

ADD script/entrypoint.sh $STORM_HOME/bin/entrypoint.sh

RUN chmod u+x $STORM_HOME/bin/entrypoint.sh

EXPOSE 3772 3773 6627 6700 6701 6702 6703 6704 6705 6706 6707 6708 6709 6710 6711 6712 6713 6714 6715 8000 8080

WORKDIR /opt/apache-storm

VOLUME /opt/apache-storm/storm_local

VOLUME /var/log/storm

ENTRYPOINT ["/bin/bash", "/opt/apache-storm/bin/entrypoint.sh"]
