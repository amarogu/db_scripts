v_historico_compras_visitanteUSE mydb;


CREATE VIEW v_stock_livros_stands AS
SELECT
    l.ISBN,
    l.Titulo,
    e.nome AS editora,
    s.numero AS numero_stand,
    s.nome_comercial AS stand,
    ss.quantidade
FROM StockStand ss
JOIN Livro l ON ss.id_livro = l.id_Livro
JOIN Stand s ON ss.id_Stand = s.id_Stand
JOIN Editora e ON l.id_editora = e.id_Editora
WHERE ss.quantidade > 0;


CREATE VIEW v_apresentacoes_disponiveis AS
SELECT
    ap.id_Apresentação,
    ap.titulo,
    ap.data_hora,
    ap.lotação_max,
    COUNT(ia.id_Inscreve_Apresentação) AS inscritos,
    ap.lotação_max - COUNT(ia.id_Inscreve_Apresentação) AS vagas_restantes,
ap.estado_vagas
FROM Apresentação ap
LEFT JOIN Inscreve_Apresentação ia
    ON ap.id_Apresentação = ia.id_increve_apresentaçao
    AND ia.estado = 'ativa'
GROUP BY ap.id_Apresentação
HAVING ap.estado_vagas = 'disponível';

CREATE VIEW v_sessoes_autografos_por_edicao AS
SELECT
    f.nome AS edicao_feira,
    a.nome AS autor,
    sa.data_hora,
    sa.localização,
    sa.lotaçao_max,
    sa.estado_vaga,
    sa.estado_tempo
FROM SessaoAutografos sa
JOIN Autor a ON sa.id_sessao_autor = a.id_Autor
JOIN Feira f ON sa.id_sessao_feira = f.id_Feira;

CREATE VIEW v_inscricoes_ativas_visitante AS
SELECT
    v.id_Visitante,
    v.nome AS visitante,
    'Apresentação' AS tipo_evento,
    ap.titulo AS evento,
    ap.data_hora,
    ia.data_incriçao,
    ia.estado
FROM Inscreve_Apresentação ia
JOIN Visitante v ON ia.id_visitante_increve = v.id_Visitante
JOIN Apresentação ap ON ia.id_increve_apresentaçao = ap.id_Apresentação
WHERE ia.estado = 'ativa'

UNION ALL

SELECT
    v.id_Visitante,
    v.nome AS visitante,
    'Sessão de Autógrafos' AS tipo_evento,
    CONCAT('Sessão - ', a.nome) AS evento,
    sa.data_hora,
    ise.Data_inscriçao,
    ise.estado
FROM Inscreve_Sessao ise
JOIN Visitante v ON ise.id_increve_sessao_visitante = v.id_Visitante
JOIN SessaoAutografos sa ON ise.id_sessao_inscreve = sa.id_SessaoAutografos
JOIN Autor a ON sa.id_sessao_autor = a.id_Autor
WHERE ise.estado = 'ativada';

CREATE VIEW v_livros_por_autor_na_feira AS
SELECT
    a.nome AS autor,
    l.Titulo AS livro,
    l.ISBN,
    s.nome_comercial AS stand,
    s.numero AS numero_stand,
    f.nome AS edicao_feira,
    ss.quantidade
FROM Livro_Autor la
JOIN Autor a ON la.id_autor = a.id_Autor
JOIN Livro l ON la.id_livro = l.id_Livro
JOIN StockStand ss ON l.id_Livro = ss.id_livro
JOIN Stand s ON ss.id_Stand = s.id_Stand
JOIN Feira f ON s.id_feira = f.id_Feira
WHERE ss.quantidade > 0;



CREATE VIEW v_historico_compras_visitante AS
SELECT
    v.nome AS visitante,
    v.email,
    l.Titulo AS livro,
    l.ISBN,
    s.nome_comercial AS stand,
    c.quantidade,
    c.preço_total,
    c.data_compra,
    f.nome AS edicao_feira
FROM Compra c
JOIN Visitante v ON c.id_visitante = v.id_Visitante
JOIN Livro l ON c.id_livro = l.id_Livro
JOIN Stand s ON c.id_stand = s.id_Stand
JOIN Feira f ON s.id_feira = f.id_Feira;
