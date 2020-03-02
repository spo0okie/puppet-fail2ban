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
		path => '/etc/fail2ban/jail.conf',
		ensure => present,
		section => 'asterisk',
		setting => 'enabled',
		value => 'true',
		notify => Service['fail2ban'],
	}
	ini_setting {'fail2ban_asterisk_ports':
		path => '/etc/fail2ban/jail.conf',
		ensure => present,
		section => 'asterisk',
		setting => 'port',
		value => '5060,5061,5038,8088',
		notify => Service['fail2ban'],
	}
	file {'fail2ban_asterisk_filter_file':
		path => '/etc/fail2ban/filter.d/asterisk.conf',
		source => 'puppet:///modules/fail2ban/filter.d/asterisk.conf',
		notify => Service['fail2ban'],
	}


}
