#!/bin/bash
# Сборка образа и запуск тестов. Запускать из корня модуля или из tests/docker/.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULE_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
IMAGE=fail2ban-module-test:latest

echo "Модуль:    $MODULE_DIR"
echo "Контекст:  $SCRIPT_DIR"

# Прокси — берём из окружения (HTTP_PROXY/HTTPS_PROXY/NO_PROXY), нужно для apt внутри сборки.
BUILD_ARGS=()
RUN_ENV=()
for v in HTTP_PROXY HTTPS_PROXY NO_PROXY http_proxy https_proxy no_proxy; do
  if [ -n "${!v:-}" ]; then
    BUILD_ARGS+=(--build-arg "$v=${!v}")
    RUN_ENV+=(-e "$v=${!v}")
  fi
done

docker build "${BUILD_ARGS[@]}" -t "$IMAGE" "$SCRIPT_DIR"

docker run --rm \
  "${RUN_ENV[@]}" \
  -v "$MODULE_DIR":/module:ro \
  -v "$SCRIPT_DIR/samples":/samples:ro \
  "$IMAGE"
