# Bloco 08 — Portal com integração e deploy contínuos

Aplicação estática em HTML, CSS e JavaScript. O catálogo pode ser pesquisado por título. O projeto não depende de pacotes npm externos.

Siga a Ficha de Trabalho 08. Trabalhe no VS Code no seu computador e use a consola do VirtualBox para os comandos destinados à VM Alpine.

## Ficheiros

- site — aplicação que os alunos completam e alteram.
- tests — testes de contagem, pesquisa e estrutura HTML.
- scripts — servidor de desenvolvimento e construção da pasta dist.
- Dockerfile e nginx.conf — imagem multi-stage e servidor do site.
- pipeline/ci-cd.yml — workflow a copiar para .github/workflows/ci-cd.yml no passo indicado.
- compose.vm.yaml — execução da imagem selecionada na VM.
- vm — configuração da verificação periódica e publicação automática.
- registo.md — evidências a guardar.

## Comandos no computador do aluno

Use Node.js 24 ou posterior.

    npm run dev
    npm run check
    npm test
    npm run build

O servidor abre em http://127.0.0.1:8080. A construção gera dist/versao.json. A pasta dist é recriada e não é guardada no Git.

## Decisão de arquitetura

O GitHub Actions executa os testes e publica a imagem no GitHub Container Registry. A VM Alpine descarrega a imagem aprovada e publica-a através de Docker Compose. A consulta ao registo acontece em cada minuto. O GitHub mostra o resultado da CI e da entrega da imagem. O registo da VM e o pedido HTTP confirmam o deploy.

O laboratório usa um repositório público com conteúdo fictício e um pacote público. O pacote começa privado e é necessário alterar a sua visibilidade nas definições do pacote depois da primeira publicação. A ficha explica o procedimento.

Os comandos de configuração da VM são executados como root numa VM individual ou de um grupo. Um único daemon Docker com acesso de administrador não separa alunos numa VM partilhada.

A VM usa a placa 1 em Bridged Adapter e DHCP. Registe o IPv4 com ip -4 addr show. A publicação usa 0.0.0.0:8088:80. No computador, abra http://IP_VM08:8088 com o IP real da VM; na VM, curl para 127.0.0.1:8088 mantém a verificação local. Não configure encaminhamento de portas. Se já existia publicação automática, volte a executar sh vm/configurar.sh com o nome da imagem: o script conserva a imagem em serviço e aplica a nova ligação de rede.

## Referências

- https://wiki.alpinelinux.org/wiki/Docker
- https://docs.github.com/en/actions/tutorials/publish-packages/publish-docker-images
- https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry
