#!/bin/bash

/opt/otrs/bin/otrs.SetPermissions.pl --otrs-user=otrs --web-group=apache

    #runuser -l otrs -c "/opt/otrs/bin/Cron.sh start"
    #runuser -l otrs -c "/opt/otrs/bin/otrs.Daemon.pl stop"
    #runuser -l otrs -c "/opt/otrs/bin/otrs.Daemon.pl start"
	rm -rf /run/httpd/httpd.pid
	runuser -l root -c "/usr/sbin/httpd -DFOREGROUND"
exec "$@"
