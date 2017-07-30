class fail2ban {
	package {'fail2ban':
		ensure => 'installed'
	} ->
	file {'/etc/rsyslog.d/fail2ban.conf':
		source => 'puppet:///modules/fail2ban/rsyslog.d/fail2ban.conf',
		mode => '0644',
		notify => Service['rsyslog']
	} ->
	ini_setting {'fail2ban_paths':
		path => '/etc/fail2ban/jail.conf',
		ensure => present,
		section => 'INCLUDES',
		setting => 'before',
		value => 'paths-fedora.conf',
		notify => Service['fail2ban']
	} ->
	ini_setting {'fail2ban_ignoreips':
		path => '/etc/fail2ban/jail.conf',
		ensure => present,
		section => 'DEFAULT',
		setting => 'ignoreip',
		value => '127.0.0.0/8 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16 176.96.80.135 94.24.244.234 87.249.213.70 62.165.38.74 95.78.163.127 78.108.201.218 95.167.177.66 78.29.0.225 193.138.130.222 213.170.92.166 80.75.132.66',
		notify => Service['fail2ban']
		#176.96.80.135 - yml-kurgan
		#94.24.244.234 - yml-chel
		#87.249.213.70 - azimut-chel-izet
		#62.165.38.74 - azimut-chel-ttk
		#95.78.163.127 - azimut-chel-ER-Telekom
		#78.108.201.218 - azimut msk
		#95.167.177.66 - azimut mhk
		#78.29.0.225 - IS74 SIP trunk
		#213.170.92.166 - sip.telphin.com
		#80.75.132.66 - voip.mtt.ru
	} ->
	ini_setting {'fail2ban_bantime':
		path => '/etc/fail2ban/jail.conf',
		ensure => present,
		section => 'DEFAULT',
		setting => 'bantime',
		value => '6000',
		notify => Service['fail2ban']
	} ->
	ini_setting {'fail2ban_findtime':
		path => '/etc/fail2ban/jail.conf',
		ensure => present,
		section => 'DEFAULT',
		setting => 'findtime',
		value => '6000',
		notify => Service['fail2ban']
	} ~>
	service {'fail2ban':
		enable => true,
		ensure => running
	}
}
