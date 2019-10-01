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
}
