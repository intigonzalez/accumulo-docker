FROM centos:7

ARG ZOOKEEPER_VERSION=3.6.1
ARG HADOOP_VERSION=2.10.0
ARG ACCUMULO_VERSION=1.9.3

RUN echo -e "\n* soft nofile 65536\n* hard nofile 65536" >> /etc/security/limits.conf

RUN yum install -y java-1.8.0-openjdk-devel make gcc-c++ wget procps-ng hostname net-tools which findutils telnet

# hadoop
ADD hadoop-${HADOOP_VERSION}.tar.gz /usr/local/
RUN ln -s /usr/local/hadoop-${HADOOP_VERSION} /usr/local/hadoop

# Zookeeper
ADD zookeeper-${ZOOKEEPER_VERSION}.tar.gz /usr/local/
RUN ln -s /usr/local/zookeeper-${ZOOKEEPER_VERSION} /usr/local/zookeeper

# Accumulo
ADD accumulo-${ACCUMULO_VERSION}-bin.tar.gz /usr/local/
RUN ln -s /usr/local/accumulo-${ACCUMULO_VERSION} /usr/local/accumulo

ENV ACCUMULO_HOME /usr/local/accumulo
ENV PATH $PATH:$ACCUMULO_HOME/bin
ADD accumulo/* $ACCUMULO_HOME/conf/

ADD start-accumulo /start-accumulo
ADD start-process /start-process

CMD ["/start-accumulo"]

EXPOSE 9999 50095 42424 9995 9997

