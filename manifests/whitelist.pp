#вынес белый список в отдельный класс, т.к. больно он громоздкий. неудобно стало
class fail2ban::whitelist {
  $wl = [
    #добавляем локальные сети в белый список
    '127.0.0.0/8 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16',

    #node0
    '94.181.46.36',

    #common ------
    '78.29.0.225',    #IS74 SIP trunk
    '213.170.92.166', #sip.telphin.com
    '80.75.132.66',   #voip.mtt.ru
    '95.167.163.148', #Rostelekom VPBX
    '212.48.197.150', #Rostelekom VPBX
    '188.234.136.49', #ДомРу ВАТС
    '5.3.4.140',      #ДомРу ВАТС
    '87.249.220.242', #Z-Телеком SIP Транк
    '62.165.32.157',  #TTK chel sip trink

    #aznode
    '87.249.213.70',  #azimut-chel-izet
    '62.165.38.74',   #azimut-chel-ttk
    '95.78.163.127',  #azimut-chel-ER-Telekom
    '78.108.201.218', #azimut msk
    '95.167.177.66',  #azimut mhk
    '212.57.99.115',  #Аэронавиком
    '95.78.177.160',  #RK Breigin

    #vova
    '94.181.47.98',     #almaz_system
    '95.78.170.226',    #chsdm
    '87.249.215.16',    #chsdm
    '100.200.100.0/24', #GKB-1 voip
  ]

  ini_setting { 'fail2ban_ignoreips':
    ensure  => present,
    require => Package['fail2ban'],
    path    => '/etc/fail2ban/jail.conf',
    section => 'DEFAULT',
    setting => 'ignoreip',
    value   => join($wl,' '),
    notify  => Service['fail2ban'],
  }
}
