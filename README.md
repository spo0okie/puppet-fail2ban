# fail2ban

Puppet-модуль установки и настройки fail2ban. Поддерживает Debian/Ubuntu и CentOS.

## Классы

- `fail2ban` — установка пакета, настройка rsyslog, базовых параметров (`bantime`, `findtime`) и подключение whitelist.
- `fail2ban::whitelist` — белый список IP (локальные сети, SIP-транки, офисные узлы).
- `fail2ban::asterisk` — jail для Asterisk (порты 5060/5061/5038/8088, фильтр из `files/filter.d/asterisk.conf`).
- `fail2ban::apache` — включение jail-ов apache-auth, apache-badbots, apache-overflows, apache-noscript, apache-nohome.

## Пример

```puppet
include fail2ban
include fail2ban::asterisk
include fail2ban::apache
```
