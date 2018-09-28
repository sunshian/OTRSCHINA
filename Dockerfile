FROM  docker.io/centos
MAINTAINER  Xi’an Dian Tong Software Co., Ltd
ENV TZ=Asia/Shanghai
RUN yum install -y epel-release && \
    yum update -y && \
    yum -y install \
	vim \
	gcc \
	make \
	httpd \ 
	httpd-devel \
	mod_perl \
        perl-core 
ADD httpd.conf /etc/httpd/conf/
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone            
EXPOSE 80 389
CMD ["/usr/sbin/httpd","-DFOREGROUND"]
