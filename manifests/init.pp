class fail2ban {
	include fail2ban::whitelist
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
	ini_setting {'fail2ban_asterisk_action':
		path => '/etc/fail2ban/jail.conf',
		ensure => present,
		section => 'asterisk',
		setting => 'action',
		value => '%(banaction)s[name=%(__name__)s-tcp, port="%(port)s", protocol="tcp", chain="%(chain)s", actname=%(banaction)s-tcp]
           %(banaction)s[name=%(__name__)s-udp, port="%(port)s", protocol="udp", chain="%(chain)s", actname=%(banaction)s-udp]',
		notify => Service['fail2ban']
	} ~>
	
	service {'fail2ban':
		enable => true,
		ensure => running
	}
}
