# VERSION 0.1
# AUTHOR:         jason.swat@gmail.com 
# DESCRIPTION:    Image with DokuWiki & lighttpd
# TO_BUILD:       docker build -t jasonswat/dokuwiki .
# TO_RUN:         docker run -d -p 80:80 jasonswat/dokuwiki

# This majority of this code is from mprasil/dokuwiki, please use that one.
# this version was modified to build on my home network, and won't work anywhere else

FROM ubuntu:14.04
MAINTAINER jason.swat@gmail.com 

# Set the version you want of Twiki
ENV DOKUWIKI_VERSION 2017-02-19 
ENV DOKUWIKI_CSUM 208cf0c9437604ac5c5a9d82c64555cb 

# Update & install packages
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install wget unzip lighttpd php5-cgi php5-gd

# Download & deploy twiki
RUN wget -O /dokuwiki.tgz \
	"http://download.dokuwiki.org/src/dokuwiki/dokuwiki-$DOKUWIKI_VERSION.tgz"
RUN if [ "$DOKUWIKI_CSUM" != "$(md5sum /dokuwiki.tgz | awk '{print($1)}')" ];\
  then echo "Wrong md5sum of downloaded file!"; exit 1; fi;
RUN tar -zxf dokuwiki.tgz
RUN mv "/dokuwiki-$DOKUWIKI_VERSION" /dokuwiki

# Install plugins
RUN cd /dokuwiki/lib/plugins && wget http://github.com/splitbrain/dokuwiki-plugin-searchindex/archive/master.zip \
  && unzip master.zip && rm master.zip
RUN cd /dokuwiki/lib/plugins && wget https://github.com/tatewake/dokuwiki-plugin-backup/archive/master.zip \
  && unzip master.zip && rm master.zip
RUN mv /dokuwiki/lib/plugins/dokuwiki-plugin-searchindex-master /dokuwiki/lib/plugins/searchindex && \
  mv /dokuwiki/lib/plugins/dokuwiki-plugin-backup-master /dokuwiki/lib/plugins/backup

# Restore from backup 
RUN cd /dokuwiki && wget http://192.168.10.184/MyWeb/software/dokuwiki_backup.tar.bz2 && \
  tar -xjf dokuwiki_backup.tar.bz2 && rm dokuwiki_backup.tar.bz2

# Set up ownership
RUN chown -R www-data:www-data /dokuwiki

# Cleanup
RUN rm dokuwiki.tgz

# Configure lighttpd
ADD dokuwiki.conf /etc/lighttpd/conf-available/20-dokuwiki.conf
RUN lighty-enable-mod dokuwiki fastcgi accesslog
RUN mkdir /var/run/lighttpd && chown www-data.www-data /var/run/lighttpd

EXPOSE 80
VOLUME ["/dokuwiki/data/","/dokuwiki/lib/plugins/","/dokuwiki/conf/","/dokuwiki/lib/tpl/","/var/log/"]

ENTRYPOINT ["/usr/sbin/lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
