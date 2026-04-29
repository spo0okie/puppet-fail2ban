#!/bin/bash
# Прогон проверок синтаксиса fail2ban в контейнере.
# Ожидает, что в /module смонтирован корень модуля, а в /samples — образцы логов.

set -euo pipefail

MODULE=/module
SAMPLES=/samples

red()   { printf '\033[31m%s\033[0m\n' "$*"; }
green() { printf '\033[32m%s\033[0m\n' "$*"; }
hdr()   { printf '\n=== %s ===\n' "$*"; }

fail=0

hdr "1. Кладём конфиги модуля в /etc/fail2ban"
install -m 0644 "$MODULE/files/filter.d/asterisk.conf" /etc/fail2ban/filter.d/asterisk.conf

# Минимальный jail.local, повторяющий то, что делает Puppet (init.pp + asterisk.pp).
# sshd выключаем — он включён в defaults-debian.conf, но к нашему модулю не относится
# и его лог в контейнере отсутствует, что ломает fail2ban-client -t.
cat >/etc/fail2ban/jail.local <<'EOF'
[DEFAULT]
bantime  = 6000
findtime = 6000
ignoreip = 127.0.0.0/8 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16

[sshd]
enabled = false

[asterisk]
enabled  = true
port     = 5060,5061,5038,8088
filter   = asterisk
logpath  = /samples/asterisk.log
bantime  = 259200
backend  = polling
EOF

hdr "2. fail2ban-client -t (полная проверка конфигурации)"
if fail2ban-client -t; then
  green "OK: конфигурация валидна"
else
  red "FAIL: fail2ban-client -t упал"
  fail=1
fi

hdr "3. fail2ban-regex по образцу asterisk.log"
# -v не используем, чтобы вывод был коротким; требуем хотя бы одно совпадение
if out=$(fail2ban-regex "$SAMPLES/asterisk.log" /etc/fail2ban/filter.d/asterisk.conf 2>&1); then
  echo "$out" | tail -n 30
  # Строка вида:  Lines: 10 lines, 0 ignored, 10 matched, 0 missed
  matched=$(echo "$out" | sed -n 's/.*Lines:.*, *\([0-9]\+\) matched.*/\1/p' | head -n1)
  missed=$(echo "$out"  | sed -n 's/.*Lines:.*, *\([0-9]\+\) missed.*/\1/p'  | head -n1)
  if [ -n "${matched:-}" ] && [ "$matched" -gt 0 ]; then
    green "OK: failregex совпал на $matched строках (missed=${missed:-?})"
  else
    red "FAIL: failregex не дал ни одного совпадения по образцу"
    fail=1
  fi
  if [ -n "${missed:-}" ] && [ "$missed" -gt 0 ]; then
    red "WARN: $missed строк не распознаны фильтром (см. --print-no-missed)"
  fi
else
  red "FAIL: fail2ban-regex завершился с ошибкой"
  echo "$out"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  green "ВСЕ ПРОВЕРКИ ПРОЙДЕНЫ"
  exit 0
else
  red "ЕСТЬ ОШИБКИ"
  exit 1
fi
