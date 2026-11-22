import { projetos, filtrarProjetos, contarProjetos } from './catalogo.js';

const pesquisa = document.querySelector('#pesquisa');
const lista = document.querySelector('#projetos');
const total = document.querySelector('#total');
const vazio = document.querySelector('#vazio');

function apresentar() {
  const encontrados = filtrarProjetos(projetos, pesquisa.value);
  lista.replaceChildren();

  for (const projeto of encontrados) {
    const artigo = document.createElement('article');
    const titulo = document.createElement('h2');
    const detalhe = document.createElement('p');
    titulo.textContent = projeto.titulo;
    detalhe.textContent = projeto.categoria + ' · ' + projeto.estado;
    artigo.append(titulo, detalhe);
    lista.append(artigo);
  }

  total.textContent = contarProjetos(encontrados) + ' projeto(s)';
  vazio.hidden = encontrados.length > 0;
}

pesquisa.addEventListener('input', apresentar);
apresentar();

fetch('./versao.json', { cache: 'no-store' })
  .then((resposta) => {
    if (!resposta.ok) throw new Error('Versão indisponível');
    return resposta.json();
  })
  .then((versao) => {
    document.querySelector('#versao').textContent =
      'Versão ' + versao.commit.slice(0, 12);
  })
  .catch(() => {
    document.querySelector('#versao').textContent = 'Versão de desenvolvimento';
  });
