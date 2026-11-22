# Registo do Bloco 08

Nome, número, grupo e data

## Ambiente
- Arquitetura do computador e da ISO escolhida.
- Prova de cat /etc/alpine-release, uname -m, docker version e docker compose version.

## Aplicação e imagem
- Captura da aplicação no browser com uma pesquisa com resultado e outra sem resultado.
- Identifique a alteração que desenvolveu e o respetivo commit.
- Saída de npm test e prova HTTP da imagem local na VM.

## Pipeline
- URL do repositório e da execução inicial com sucesso.
- Nome do job que executa os testes e condição que permite publicar a imagem.
- Commit, imagem e digest apresentados no resumo do workflow.

## Integração contínua
- Ramo e pull request do ensaio.
- Commit com o erro de contagem, teste que falhou e saída observada.
- Commit de correção, verificação concluída e integração em main.

## Deploy contínuo
- Duas saídas de versao.json com commits distintos.
- Linha DEPLOY CONCLUÍDO para cada versão.
- Prova de que o commit servido coincide com a revisão integrada em main.
- Explique por que razão não foi necessário configurar acesso de entrada do GitHub à VM.

## Recuperação
- Commit recuperado com git revert e novo commit que regista essa decisão.
- Prova HTTP da publicação que repõe o conteúdo anterior.
- Distinga a entrega de uma imagem no registo da confirmação de que a VM a serve.

## Rede bridge
- Interface física selecionada, IPv4 da VM e URL http://IP_VM08:8088 usado no computador.
- Confirmação do mesmo commit por HTTP dentro da VM e no browser do computador.
