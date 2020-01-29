FROM ubuntu:19.10

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y rsyslog supervisor swift python3-swiftclient rsync \
                       swift-proxy swift-object memcached python3-keystoneclient \
                       python3-swiftclient python3-netifaces \
                       python3-xattr python3-memcache \
                       swift-account swift-container swift-object pwgen

RUN mkdir -p /var/log/supervisor
RUN mkdir -p /srv/sdb1
ADD files/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#
# Swift configuration
# - Partially fom http://docs.openstack.org/developer/swift/development_saio.html
#

# not sure how valuable dispersion will be...
ADD files/dispersion.conf /etc/swift/dispersion.conf
ADD files/rsyncd.conf /etc/rsyncd.conf
ADD files/swift.conf /etc/swift/swift.conf
ADD files/proxy-server.conf /etc/swift/proxy-server.conf
ADD files/account-server.conf /etc/swift/account-server.conf
ADD files/object-server.conf /etc/swift/object-server.conf
ADD files/container-server.conf /etc/swift/container-server.conf
ADD files/proxy-server.conf /etc/swift/proxy-server.conf
ADD files/10-swift.conf /etc/rsyslog.d/10-swift.conf
ADD files/startmain.sh /usr/local/bin/startmain.sh
RUN chmod 755 /usr/local/bin/*.sh

EXPOSE 8080

CMD /usr/local/bin/startmain.sh
