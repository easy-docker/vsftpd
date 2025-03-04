FROM centos:7

MAINTAINER Fer Uria <fauria@gmail.com>
LABEL Description="vsftpd Docker image based on Centos 7. Supports passive mode and virtual users." \
	License="Apache License 2.0" \
	Usage="docker run -d -p [HOST PORT NUMBER]:21 -v [HOST FTP HOME]:/vsftpd fauria/vsftpd" \
	Version="1.0"

COPY vsftpd.conf /etc/vsftpd/
COPY vsftpd_virtual /etc/pam.d/
COPY run-vsftpd.sh /usr/sbin/

RUN yum -y update && yum clean all
RUN yum install -y vsftpd db4-utils iproute && yum clean all
RUN usermod -u 33 -g 33 ftp \
    && groupmod -n ftpold ftp \
    && groupmod -n ftp tape \
    && chmod +x /usr/sbin/run-vsftpd.sh \
    && mkdir -p /vsftpd/ \
    && mkdir -p /config/user \
    && mkdir -p /logs \
    && chown -R ftp:ftp /vsftpd/

ENV FTP_USER **String**
ENV FTP_PASS **Random**
ENV PASV_ADDRESS **IPv4**
ENV PASV_ADDR_RESOLVE NO
ENV PASV_ENABLE YES
ENV PASV_MIN_PORT 21100
ENV PASV_MAX_PORT 21110
ENV XFERLOG_STD_FORMAT NO
ENV LOG_STDOUT YES
ENV FILE_OPEN_MODE 0666
ENV LOCAL_UMASK 077
ENV REVERSE_LOOKUP_ENABLE YES
ENV PASV_PROMISCUOUS NO
ENV PORT_PROMISCUOUS NO

VOLUME /vsftpd
VOLUME /logs
VOLUME /config

EXPOSE 20 21

CMD ["/usr/sbin/run-vsftpd.sh"]
