FROM  docker.io/centos
MAINTAINER  Xi’an Dian Tong Software Co., Ltd
RUN useradd -d /opt/otrs/ -c 'OTRS user' otrs
#需明确用户UID和GID,便于后期挂载文件。
#usermod  -u   555 ftp_rw && groupmod  -g  555 ftp_rw 修改uid和Gid
#cat /etc/passwd |grep id  查看uid和Gid
ADD otrs /opt/otrs
ENV TZ=Asia/Shanghai
RUN yum install -y epel-release && \
    yum update -y && \
    yum -y install \
	cronie \ 
	vim \
	gcc \
	make \
	httpd \ 
	httpd-devel \
	mod_perl \
    perl-core \
	"perl(Crypt::SSLeay)" \
	"perl(Net::LDAP)" \
	"perl(URI)" \
	"perl(Spreadsheet::ParseExcel)" \
     procmail \
	"perl(Date::Format)" \
	"perl(LWP::UserAgent)" \
    "perl(Net::DNS)" \
	"perl(IO::Socket::SSL)" \
	"perl(XML::Parser)" \
    "perl(Apache2::Reload)" \
	"perl(Crypt::Eksblowfish::Bcrypt)" \
    "perl(Encode::HanExtra)" \
	"perl(GD)" \
	"perl(GD::Text)" \
	"perl(GD::Graph)" \
    "perl(JSON::XS)" \
	"perl(Mail::IMAPClient)" \
	"perl(PDF::API2)" \
	"perl(DateTime)" \
    "perl(Text::CSV_XS)" \
	"perl(YAML::XS)" \
	"perl(Text::CSV_XS)" \
	"perl(DBD::mysql)" \
	"perl(DBD::Pg)" \
	"perl(Archive::Zip)" \
	"perl(Authen::NTLM)" \
	"perl(Template)" \
	"perl(Template::Stash::XS)" \
	"perl(XML::LibXML)" \ 
	"perl(Sys::Syslog)" \
	"perl(XML::LibXSLT)"

ADD httpd.conf /etc/httpd/conf/

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone            
RUN chown -R otrs.apache /opt/otrs/ \
        && chmod -R 775 /opt/otrs/ 

RUN cd /opt/otrs \
            && cp /opt/otrs/Kernel/Config.pm.dist /opt/otrs/Kernel/Config.pm \
            && cp /opt/otrs/var/cron/otrs_daemon.dist /opt/otrs/var/cron/otrs_daemon \
			&& chmod 775 /opt/otrs/var/cron/otrs_daemon \
            && chmod +x /opt/otrs/bin/otrs.SetPermissions.pl \
			&& chmod 775 -R /opt/otrs \
            && /opt/otrs/bin/otrs.SetPermissions.pl  --web-group=apache --otrs-user=otrs \
            && chmod 644 /opt/otrs/scripts/apache2-httpd.include.conf \
            && rm -rf /var/lib/* 
EXPOSE 80 389
CMD ["/usr/sbin/httpd","-DFOREGROUND"]
