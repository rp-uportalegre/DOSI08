export const projetos = [
  { titulo: 'Portefólio digital', categoria: 'Web', estado: 'Concluído' },
  { titulo: 'Agenda da turma', categoria: 'JavaScript', estado: 'Em curso' },
  { titulo: 'Portal de eventos', categoria: 'Web', estado: 'Em curso' }
];

export function filtrarProjetos(lista, termo = '') {
  const pesquisa = termo.trim().toLocaleLowerCase('pt-PT');

  return lista.filter((projeto) => {
    const texto = projeto.titulo + ' ' + projeto.categoria;

    return texto.toLocaleLowerCase('pt-PT').includes(pesquisa);
  });
}

export function contarProjetos(lista) {
  return lista.length;
}
