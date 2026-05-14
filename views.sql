USE mydb;

DROP VIEW IF EXISTS v_stock_livros_stands;
DROP VIEW IF EXISTS v_apresentacoes_disponiveis;
DROP VIEW IF EXISTS v_sessoes_autografos_por_edicao;
DROP VIEW IF EXISTS v_inscricoes_ativas_visitante;
DROP VIEW IF EXISTS v_livros_por_autor_na_feira;
DROP VIEW IF EXISTS v_historico_compras_visitante;


CREATE VIEW v_stock_livros_stands AS
SELECT
    l.ISBN,
    l.titulo,
    e.nome AS editora,
    s.numero AS numero_stand,
    s.nome_comercial AS stand,
    ss.quantidade
FROM StockStand ss
JOIN Livro l   ON ss.id_livro = l.id_livro
JOIN Stand s   ON ss.id_stand = s.id_stand
JOIN Editora e ON l.id_editora = e.id_editora
WHERE ss.quantidade > 0;


CREATE VIEW v_apresentacoes_disponiveis AS
SELECT
    ap.id_apresentacao,
    ap.titulo,
    ap.data_hora,
    ap.lotacao_max,
    COUNT(ia.id_inscreve_apresentacao) AS inscritos,
    ap.lotacao_max - COUNT(ia.id_inscreve_apresentacao) AS vagas_restantes,
    ap.estado_vagas
FROM Apresentacao ap
LEFT JOIN Inscreve_Apresentacao ia
       ON ap.id_apresentacao = ia.id_apresentacao
      AND ia.estado = 'ativa'
GROUP BY ap.id_apresentacao
HAVING ap.estado_vagas = 'disponivel';


CREATE VIEW v_sessoes_autografos_por_edicao AS
SELECT
    f.nome AS edicao_feira,
    a.nome AS autor,
    sa.data_hora,
    sa.localizacao,
    sa.lotacao_max,
    sa.estado_vagas,
    sa.estado_tempo
FROM SessaoAutografos sa
JOIN Autor a ON sa.id_autor = a.id_autor
JOIN Feira f ON sa.id_feira = f.id_feira;


CREATE VIEW v_inscricoes_ativas_visitante AS
SELECT
    v.id_visitante,
    v.nome AS visitante,
    'Apresentacao' AS tipo_evento,
    ap.titulo AS evento,
    ap.data_hora,
    ia.data_inscricao,
    ia.estado
FROM Inscreve_Apresentacao ia
JOIN Visitante v    ON ia.id_visitante    = v.id_visitante
JOIN Apresentacao ap ON ia.id_apresentacao = ap.id_apresentacao
WHERE ia.estado = 'ativa'

UNION ALL

SELECT
    v.id_visitante,
    v.nome AS visitante,
    'Sessao de Autografos' AS tipo_evento,
    CONCAT('Sessao - ', a.nome) AS evento,
    sa.data_hora,
    ise.data_inscricao,
    ise.estado
FROM Inscreve_Sessao ise
JOIN Visitante v        ON ise.id_visitante = v.id_visitante
JOIN SessaoAutografos sa ON ise.id_sessao    = sa.id_sessao
JOIN Autor a             ON sa.id_autor     = a.id_autor
WHERE ise.estado = 'ativa';


CREATE VIEW v_livros_por_autor_na_feira AS
SELECT
    a.nome AS autor,
    l.titulo AS livro,
    l.ISBN,
    s.nome_comercial AS stand,
    s.numero AS numero_stand,
    f.nome AS edicao_feira,
    ss.quantidade
FROM Livro_Autor la
JOIN Autor a      ON la.id_autor = a.id_autor
JOIN Livro l      ON la.id_livro = l.id_livro
JOIN StockStand ss ON l.id_livro = ss.id_livro
JOIN Stand s      ON ss.id_stand = s.id_stand
JOIN Feira f      ON s.id_feira = f.id_feira
WHERE ss.quantidade > 0;


CREATE VIEW v_historico_compras_visitante AS
SELECT
    v.nome AS visitante,
    v.email,
    l.titulo AS livro,
    l.ISBN,
    s.nome_comercial AS stand,
    c.quantidade,
    c.preco_total,
    c.data_compra,
    f.nome AS edicao_feira
FROM Compra c
JOIN Visitante v ON c.id_visitante = v.id_visitante
JOIN Livro l     ON c.id_livro     = l.id_livro
JOIN Stand s     ON c.id_stand     = s.id_stand
JOIN Feira f     ON s.id_feira     = f.id_feira;
