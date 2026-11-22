import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { contarProjetos, filtrarProjetos, projetos } from '../site/catalogo.js';

test('a contagem corresponde ao número de projetos recebidos', () => {
  assert.equal(contarProjetos(projetos), 3);
  assert.equal(contarProjetos([]), 0);
});

test('a pesquisa encontra um título sem distinguir maiúsculas', () => {
  assert.equal(filtrarProjetos(projetos, 'AGENDA')[0].titulo, 'Agenda da turma');
});

test('a pesquisa ignora espaços antes e depois do termo', () => {
  assert.equal(filtrarProjetos(projetos, ' agenda ').length, 1);
});

test('a pesquisa sem resultados devolve uma lista vazia', () => {
  assert.deepEqual(filtrarProjetos(projetos, 'inexistente'), []);
});

test('a pesquisa vazia apresenta todos os projetos', () => {
  assert.equal(filtrarProjetos(projetos).length, 3);
});

test('a pesquisa mantém a lista original', () => {
  filtrarProjetos(projetos, 'agenda');
  assert.equal(projetos.length, 3);
});

test('o HTML contém os elementos usados pela aplicação', async () => {
  const html = await readFile(new URL('../site/index.html', import.meta.url), 'utf8');
  for (const id of ['pesquisa', 'projetos', 'total', 'vazio', 'versao']) {
    assert.ok(html.includes('id="' + id + '"'), 'Elemento em falta: ' + id);
  }
  assert.ok(html.includes('lang="pt-PT"'));
});

test('a pesquisa encontra a categoria', () => {
  assert.equal(filtrarProjetos(projetos, 'WEB').length, 2);
});