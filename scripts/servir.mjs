import { createServer } from 'node:http';
import { readFile } from 'node:fs/promises';

const ficheiros = new Map([
  ['/', ['site/index.html', 'text/html; charset=utf-8']],
  ['/index.html', ['site/index.html', 'text/html; charset=utf-8']],
  ['/app.js', ['site/app.js', 'text/javascript; charset=utf-8']],
  ['/catalogo.js', ['site/catalogo.js', 'text/javascript; charset=utf-8']],
  ['/estilos.css', ['site/estilos.css', 'text/css; charset=utf-8']]
]);

createServer(async (pedido, resposta) => {
  const caminho = new URL(pedido.url, 'http://localhost').pathname;
  if (caminho === '/versao.json') {
    resposta.writeHead(200, { 'Content-Type': 'application/json' });
    resposta.end(JSON.stringify({ commit: 'local' }));
    return;
  }
  const entrada = ficheiros.get(caminho);
  if (!entrada) {
    resposta.writeHead(404).end('Página inexistente');
    return;
  }
  try {
    const dados = await readFile(entrada[0]);
    resposta.writeHead(200, { 'Content-Type': entrada[1] });
    resposta.end(dados);
  } catch {
    resposta.writeHead(500).end('Erro ao ler o ficheiro');
  }
}).listen(8080, '127.0.0.1', () => {
  console.log('Abra http://127.0.0.1:8080. Termine com Ctrl+C.');
});
