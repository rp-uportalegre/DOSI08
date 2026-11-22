#!/bin/sh
set -eu

if [ "$(id -u)" -ne 0 ]; then
  echo "Execute este comando como root na VM Alpine." >&2
  exit 1
fi

imagem=${1:-}
if ! printf '%s\n' "$imagem" | grep -Eq '^ghcr\.io/[a-z0-9_.-]+/[a-z0-9_.-]+$'; then
  echo "Uso: sh vm/configurar.sh ghcr.io/utilizador/dosi08-portal" >&2
  exit 1
fi

origem=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
destino=/opt/dosi08
mkdir -p "$destino"
exec 9>"$destino/.atualizar.lock"
flock 9
cp "$origem/compose.vm.yaml" "$destino/compose.vm.yaml"
cp "$origem/vm/atualizar.sh" "$destino/atualizar.sh"
printf '%s\n' "$imagem" > "$destino/imagem"
chmod 700 "$destino" "$destino/atualizar.sh"
chmod 600 "$destino/imagem"
# Reaplicar a rede a uma publicação existente, conservando a imagem em serviço.
contentor=$(docker ps -q --filter label=com.docker.compose.project=dosi08 --filter label=com.docker.compose.service=portal)
if [ -n "$contentor" ]; then
  referencia=$(docker inspect --format '{{.Config.Image}}' "$contentor")
  IMAGEM_PORTAL="$referencia" docker compose -p dosi08 -f "$destino/compose.vm.yaml" up -d --force-recreate --wait --wait-timeout 60
fi

temporario=$(mktemp)
trap 'rm -f "$temporario"' EXIT HUP INT TERM

{ crontab -l 2>/dev/null || true; } | grep -v '/opt/dosi08/atualizar.sh' > "$temporario" || true
printf '%s\n' '* * * * * /bin/sh /opt/dosi08/atualizar.sh >> /var/log/dosi08.log 2>&1' >> "$temporario"
crontab "$temporario"
flock -u 9
rc-update add crond default
rc-service crond start
echo "CD configurado. A VM procura uma nova imagem em cada minuto."
echo "Execute sh /opt/dosi08/atualizar.sh para fazer a primeira publicação."
