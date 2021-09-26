
REPOSITORY=cybermaggedon/accumulo
ZOOKEEPER_VERSION=3.4.8
HADOOP_VERSION=2.9.2
ACCUMULO_VERSION=1.10.1
DOCKER=podman

# TODO
# - do -D and -S in both the docker container and the host as described in https://man7.org/linux/man-pages/man5/ext4.5.html
#    https://linux.die.net/man/8/mount
#    http://hadoop-hbase.blogspot.com/2013/07/protected-hbase-against-data-center.html
# - fix how accumulo is shutted down

SUDO=
BUILD_ARGS=--build-arg ZOOKEEPER_VERSION=${ZOOKEEPER_VERSION} \
  --build-arg HADOOP_VERSION=${HADOOP_VERSION} \
  --build-arg ACCUMULO_VERSION=${ACCUMULO_VERSION}

DOWNLOADS=accumulo-${ACCUMULO_VERSION}-bin.tar.gz \
  zookeeper-${ZOOKEEPER_VERSION}.tar.gz hadoop-${HADOOP_VERSION}.tar.gz

all: ${DOWNLOADS}
	${SUDO} ${DOCKER} build ${BUILD_ARGS} -t ${REPOSITORY}:${ACCUMULO_VERSION} .
	${SUDO} ${DOCKER} tag ${REPOSITORY}:${ACCUMULO_VERSION} ${REPOSITORY}:latest

# FIXME: May not be the right mirror for you.
zookeeper-${ZOOKEEPER_VERSION}.tar.gz:
	wget -O $@ https://archive.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz

# FIXME: May not be the right mirror for you.
accumulo-${ACCUMULO_VERSION}-bin.tar.gz:
	wget -O $@ https://apache.mirrors.nublue.co.uk/accumulo/${ACCUMULO_VERSION}/accumulo-${ACCUMULO_VERSION}-bin.tar.gz

# FIXME: May not be the right mirror for you.
hadoop-${HADOOP_VERSION}.tar.gz:
	wget -O $@ https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz

push:
	${SUDO} ${DOCKER} push ${REPOSITORY}:${VERSION}
	${SUDO} ${DOCKER} push ${REPOSITORY}:latest
