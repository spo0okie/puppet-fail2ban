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

## Тесты

Базовая проверка конфигов в Docker (нужен docker, прокси берётся из окружения):

```sh
./tests/docker/test.sh
```

Что делает: ставит fail2ban в Debian-контейнер, копирует [files/filter.d/asterisk.conf](files/filter.d/asterisk.conf), генерирует jail.local по образу `init.pp` + `asterisk.pp`, прогоняет `fail2ban-client -t` и `fail2ban-regex` по образцу [tests/docker/samples/asterisk.log](tests/docker/samples/asterisk.log). Падает, если синтаксис конфигурации сломан или фильтр не распознаёт ни одной строки.
