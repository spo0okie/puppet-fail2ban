#класс установки и настройки fail2ban
class fail2ban {
  case $facts['os']['name'] {
    'CentOS': {
      $paths_include = 'paths-fedora.conf'
    }
    'Debian', 'Ubuntu': {
      $paths_include = 'paths-debian.conf'
    }
    default: {
      fail("Неподдерживаемая ОС: ${facts['os']['name']}")
    }
  }

  include fail2ban::whitelist

  package { 'fail2ban':
    ensure => 'installed',
  }
  -> file { '/etc/rsyslog.d/fail2ban.conf':
    source => 'puppet:///modules/fail2ban/rsyslog.d/fail2ban.conf',
    mode   => '0644',
    notify => Service['rsyslog'],
  }
  -> ini_setting { 'fail2ban_paths':
    ensure  => present,
    path    => '/etc/fail2ban/jail.conf',
    section => 'INCLUDES',
    setting => 'before',
    value   => $paths_include,
    notify  => Service['fail2ban'],
  }
  -> ini_setting { 'fail2ban_bantime':
    ensure  => present,
    path    => '/etc/fail2ban/jail.conf',
    section => 'DEFAULT',
    setting => 'bantime',
    value   => '6000',
    notify  => Service['fail2ban'],
  }
  -> ini_setting { 'fail2ban_findtime':
    ensure  => present,
    path    => '/etc/fail2ban/jail.conf',
    section => 'DEFAULT',
    setting => 'findtime',
    value   => '6000',
    notify  => Service['fail2ban'],
  }
  ~> service { 'fail2ban':
    ensure => running,
    enable => true,
  }
}
