import { cp, mkdir, rm, writeFile } from 'node:fs/promises';

const commit = process.env.VERSAO || 'local';
if (!/^(local|[a-f0-9]{40})$/.test(commit)) {
  throw new Error('VERSAO deve ser local ou o identificador completo do commit.');
}

await rm('dist', { recursive: true, force: true });
await mkdir('dist');
await cp('site', 'dist', { recursive: true });
await writeFile('dist/versao.json', JSON.stringify({ commit }) + '\n');
console.log('Aplicação construída. Versão ' + commit);
