# Класс настройки fail2ban для Apache
class fail2ban::apache {
  include fail2ban

  $logroot = $apache::params::logroot

  # выявляем неудачные попытки ввода пароля
  ini_setting { 'fail2ban_apache_auth':
    ensure  => present,
    path    => '/etc/fail2ban/jail.conf',
    section => 'apache-auth',
    setting => 'enabled',
    value   => 'true',
    require => Package['fail2ban'],
    notify  => Service['fail2ban'],
  }

  # выявляем спамерких ботов, ищущих имейлы
  ini_setting { 'fail2ban_apache_badbots':
    ensure  => present,
    path    => '/etc/fail2ban/jail.conf',
    section => 'apache-badbots',
    setting => 'enabled',
    value   => 'true',
    require => Package['fail2ban'],
    notify  => Service['fail2ban'],
  }

  # выявляем попытки переполнения Апача
  ini_setting { 'fail2ban_apache_overflows':
    ensure  => present,
    path    => '/etc/fail2ban/jail.conf',
    section => 'apache-overflows',
    setting => 'enabled',
    value   => 'true',
    require => Package['fail2ban'],
    notify  => Service['fail2ban'],
  }

  # выявление, потенциальный поиск эксплойтов и php
  ini_setting { 'fail2ban_apache_noscript':
    ensure  => present,
    path    => '/etc/fail2ban/jail.conf',
    section => 'apache-noscript',
    setting => 'enabled',
    value   => 'true',
    require => Package['fail2ban'],
    notify  => Service['fail2ban'],
  }

  # выявляем неудачные попытки выполнить несуществующие скрипты,
  # которые ассоциированы с некоторыми популярными веб-сервисами
  # например, webmail, phpMyAdmin, WordPress
  ini_setting { 'fail2ban_apache_nohome':
    ensure  => present,
    path    => '/etc/fail2ban/jail.conf',
    section => 'apache-nohome',
    setting => 'enabled',
    value   => 'true',
    require => Package['fail2ban'],
    notify  => Service['fail2ban'],
  }

  ini_setting { 'apache_error_log':
    ensure  => present,
    path    => '/etc/fail2ban/jail.conf',
    section => 'DEFAULT',
    setting => 'apache_error_log',
    value   => "${logroot}/*error[_\\.]log",
    notify  => Service['fail2ban'],
  }

  ini_setting { 'apache_access_log':
    ensure  => present,
    path    => '/etc/fail2ban/jail.conf',
    section => 'DEFAULT',
    setting => 'apache_access_log',
    value   => "${logroot}/*access[_\\.]log",
    notify  => Service['fail2ban'],
  }
}
