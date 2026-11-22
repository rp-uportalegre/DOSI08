#!/bin/sh
set -eu

base=${DOSI08_DIR:-/opt/dosi08}
exec 9>"$base/.atualizar.lock"
flock -n 9 || exit 0

registar() {
  printf '%s %s\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" "$*"
}

implantar() {
  IMAGEM_PORTAL="$1" docker compose -p dosi08     -f "$base/compose.vm.yaml" up -d --wait --wait-timeout 60
}

imagem=$(cat "$base/imagem")
if ! printf '%s\n' "$imagem" | grep -Eq '^ghcr\.io/[a-z0-9_.-]+/[a-z0-9_.-]+$'; then
  registar "ERRO: o nome da imagem no ficheiro imagem é inválido."
  exit 1
fi

if ! docker pull "$imagem:main"; then
  registar "ERRO: não foi possível descarregar a imagem. Verifique a rede e as permissões do pacote."
  exit 1
fi

nova=$(docker image inspect --format '{{.Id}}' "$imagem:main")
referencia=$(docker image inspect --format '{{index .RepoDigests 0}}' "$imagem:main")
esperada=$(docker image inspect --format '{{index .Config.Labels "org.opencontainers.image.revision"}}' "$nova")
if ! printf '%s\n' "$esperada" | grep -Eq '^[a-f0-9]{40}$'; then
  registar "ERRO: a imagem não identifica um commit válido."
  exit 1
fi

contentor=$(docker ps -q   --filter label=com.docker.compose.project=dosi08   --filter label=com.docker.compose.service=portal)
anterior=
referencia_anterior=
if [ -n "$contentor" ]; then
  anterior=$(docker inspect --format '{{.Image}}' "$contentor")
  referencia_anterior=$(docker image inspect --format '{{index .RepoDigests 0}}' "$anterior")
fi

if [ "$nova" = "$anterior" ]; then
  registar "SEM ALTERAÇÕES: a VM já executa o commit $esperada."
  exit 0
fi

registar "INÍCIO DO DEPLOY: commit $esperada."
if implantar "$referencia" &&
  servida=$(curl -fsS --max-time 10 http://127.0.0.1:8088/versao.json) &&
  printf '%s\n' "$servida" | grep -Fq "$esperada" &&
  curl -fsS --max-time 10 http://127.0.0.1:8088/ > /dev/null; then
  registar "DEPLOY CONCLUÍDO: HTTP confirmado para o commit $esperada."
  exit 0
fi

registar "FALHA NO DEPLOY: a versão nova falhou na verificação."
if [ -n "$anterior" ]; then
  if implantar "$referencia_anterior"; then
    registar "RECUPERAÇÃO CONCLUÍDA: imagem anterior $anterior."
  else
    registar "ERRO NA RECUPERAÇÃO: consulte docker compose e os logs do portal."
  fi
else
  registar "Primeira publicação: ainda não existe uma versão anterior."
fi
exit 1
