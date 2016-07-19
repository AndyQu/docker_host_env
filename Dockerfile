#这个Dockerfile创建的image，用于在机器上部署C端+Server端联合测试环境
FROM		ubuntu:16.04
MAINTAINER	quguocheng
#http://blog.packagecloud.io/eng/2016/03/21/apt-hash-sum-mismatch/
RUN		apt-get update -o Acquire::CompressionTypes::Order::=gz
RUN		export	TERM=${TERM:-dumb}


RUN		apt-get -y --fix-missing install git
#RUN		apt-get -y install openssh-client
ENV		GRADLE_USER_HOME=/root/.gradle/
RUN		echo "export GRADLE_USER_HOME=/root/.gradle/" >> /root/.bashrc
RUN		echo "export TERM=\${TERM:-dumb}" >> /root/.bashrc


WORKDIR		/usr/local/
RUN		apt-get -y install wget
RUN		apt-get -y install unzip
RUN		wget http://download.eclipse.org/jetty/8.1.17.v20150415/dist/jetty-distribution-8.1.17.v20150415.zip
RUN		unzip jetty-distribution-8.1.17.v20150415.zip

WORKDIR		/usr/local/jetty-distribution-8.1.17.v20150415/bin/
RUN 		echo "JAVA_OPTIONS=\"-Xdebug -Xrunjdwp:transport=dt_socket,address=0.0.0.0:8000,server=y,suspend=n\"" > tmp_jetty.sh
RUN		cat jetty.sh >> tmp_jetty.sh
RUN		cat tmp_jetty.sh > jetty.sh
RUN		chmod +x jetty.sh

ENV		JETTY_HOME=/usr/local/jetty-distribution-8.1.17.v20150415
ENV		JETTY_PORT=8088

ENV		LANG=C.UTF-8

RUN		apt-get -y --fix-missing install openjdk-8-jdk
