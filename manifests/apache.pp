class fail2ban::apache {
	include fail2ban
	$logroot = $::apache::params::logroot
	# выявляем неудачные попытки ввода пароля
	ini_setting {'fail2ban_apache_auth':
		require => Package['fail2ban'],
		path => '/etc/fail2ban/jail.conf',
		ensure => present,
		section => 'apache-auth',
		setting => 'enabled',
		value => 'true',
		notify => Service['fail2ban'],
	}
	# выявляем спамерких ботов, ищущих имейлы
	ini_setting {'fail2ban_apache_badbots':
		require => Package['fail2ban'],
		path => '/etc/fail2ban/jail.conf',
		ensure => present,
		section => 'apache-badbots',
		setting => 'enabled',
		value => 'true',
		notify => Service['fail2ban'],
	}
	# выявляем попытки переполнения Апача
	ini_setting {'fail2ban_apache_overflows':
		require => Package['fail2ban'],
		path => '/etc/fail2ban/jail.conf',
		ensure => present,
		section => 'apache-overflows',
		setting => 'enabled',
		value => 'true',
		notify => Service['fail2ban'],
	}
	# выявление, потенциальный поиск эксплойтов и php 
	ini_setting {'fail2ban_apache_noscript':
		require => Package['fail2ban'],
		path => '/etc/fail2ban/jail.conf',
		ensure => present,
		section => 'apache-noscript',
		setting => 'enabled',
		value => 'true',
		notify => Service['fail2ban'],
	}
	# выявляем неудачные попытки выполнить не существующие скрипты
	# которые ассоциированы с некоторым популярными веб-сервисами
	# например, webmail, phpMyAdmin, WordPress
	ini_setting {'fail2ban_apache_nohome':
		require => Package['fail2ban'],
		path => '/etc/fail2ban/jail.conf',
		ensure => present,
		section => 'apache-nohome',
		setting => 'enabled',
		value => 'true',
		notify => Service['fail2ban'],
	}
	ini_setting {'apache_error_log':
		path => '/etc/fail2ban/jail.conf',
		ensure => present,
		section => 'DEFAULT',
		setting => 'apache_error_log',
		value => "$logroot/*error[_\.]log",
		notify => Service['fail2ban']
	}
	ini_setting {'apache_access_log':
		path => '/etc/fail2ban/jail.conf',
		ensure => present,
		section => 'DEFAULT',
		setting => 'apache_access_log',
		value => "$logroot/*access[_\.]log",
		notify => Service['fail2ban']
	}
}

