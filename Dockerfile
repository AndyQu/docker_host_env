#这个Dockerfile创建的image，用于在机器上部署C端+Server端联合测试环境
FROM		ubuntu:16.04
MAINTAINER	quguocheng
RUN		echo "[Begin]"
RUN		apt-get update
#RUN		apt-get -y --fix-missing install software-properties-common python-software-properties
RUN		apt-get -y --fix-missing install software-properties-common
RUN		add-apt-repository ppa:webupd8team/java
RUN		apt-get update
#RUN		export	TERM=${TERM:-dumb}
RUN		echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN		echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
RUN		apt-get -y install oracle-java8-installer
#RUN		apt-get -y install openjdk-7-jdk

RUN		apt-get -y install gradle
RUN		apt-get -y install git
RUN		apt-get -y install openssh-client
ENV		GRADLE_USER_HOME=/root/.gradle/
RUN		echo "export GRADLE_USER_HOME=/root/.gradle/" >> /root/.bashrc
RUN		echo "export TERM=\${TERM:-dumb}" >> /root/.bashrc

RUN		apt-get update
RUN		apt-get -y install ruby ruby-dev ctags pngquant

#node软件
RUN		apt-get -y install wget
WORKDIR		/tmp/
RUN		["wget", "https://raw.githubusercontent.com/creationix/nvm/v0.23.2/install.sh"]
RUN		bash install.sh
RUN		rm /bin/sh && ln -s /bin/bash /bin/sh
RUN		source /root/.nvm/nvm.sh && nvm install 0.12.4
RUN		source /root/.nvm/nvm.sh && nvm use v0.12.4
RUN		source /root/.nvm/nvm.sh && nvm install iojs

RUN		apt-get install make
RUN 		gem install --user-install bundler

WORKDIR		/usr/local/
#RUN		wget http://download.eclipse.org/jetty/stable-8/dist/jetty-distribution-8.1.17.v20150415.zip
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

ENV		PATH /root/.nvm/versions/io.js/v3.3.1/bin/:$PATH

RUN		apt-get -y install python
RUN		apt-get -y install g++
RUN		apt-get -y install curl
