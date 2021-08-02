FROM centos
MAINTAINER Steven-zn <974038167@qq.com>

RUN yum update -y
RUN curl -s https://packagecloud.io/install/repositories/akopytov/sysbench/script.rpm.sh | bash
RUN yum install -y sysbench

CMD tail -f /var/log/messages
