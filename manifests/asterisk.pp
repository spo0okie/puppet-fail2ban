class fail2ban::asterisk {
	include fail2ban
	exec { 'test_asterisk_logs':
		command	=> "/bin/true",
		onlyif	=> "test -f /var/log/asterisk/messages",
		path	=> ['/usr/bin','/usr/sbin','/bin','/sbin'],
	}
	ini_setting {'fail2ban_asterisk_bantime':
		require => [
			Exec['test_asterisk_logs'],
			Package['fail2ban'],
			Service['asterisk']
		],
		path => '/etc/fail2ban/jail.conf',
		ensure => present,
		section => 'asterisk',
		setting => 'bantime',
		value => '259200',
		notify => Service['fail2ban'],
	}
	ini_setting {'fail2ban_asterisk_enable':
		require => Ini_setting['fail2ban_asterisk_bantime'],
		path => '/etc/fail2ban/jail.conf',
		ensure => present,
		section => 'asterisk',
		setting => 'enabled',
		value => 'true',
		notify => Service['fail2ban'],
	}
	ini_setting {'fail2ban_asterisk_action':
		path => '/etc/fail2ban/jail.conf',
		ensure => present,
		section => 'asterisk',
		setting => 'action',
		value => '%(banaction)s[name=%(__name__)s-tcp, port="%(port)s", protocol="tcp", chain="%(chain)s", actname=%(banaction)s-tcp]
           %(banaction)s[name=%(__name__)s-udp, port="%(port)s", protocol="udp", chain="%(chain)s", actname=%(banaction)s-udp]',
		notify => Service['fail2ban']
	}
	
}
