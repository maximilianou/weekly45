alpine_firewall: 
	apk update && apk upgrade
	apk add ip6tables iptables
	apk add -u awall
	apk version awall
alpine_kernel_load_module:
	modprobe -v ip_tables
	modprobe -v ip6_tables
	modprobe -v iptable_nat
	rc-update add iptables
	rc-update add ip6tables
#alpine_firewall_service_start:
#	ls -l /etc/iptables/
#	cat /etc/iptables/rules-save
#	rc-service iptables {start|stop|restart|status}
#	rc-service ip6tables {start|stop|restart|status}

