USE mydb;

-- Q1
SELECT stand, numero_stand, quantidade
FROM v_stock_livros_stands
WHERE titulo = 'Nome do Livro'
   OR ISBN = '9789720706530';

-- Q2

SELECT titulo, data_hora, lotacao_max, estado_vagas
FROM Apresentacao
WHERE DATE(data_hora) = '2026-06-15';

-- Q3

SELECT autor, data_hora, localizacao, estado_vagas
FROM v_sessoes_autografos_por_edicao
WHERE edicao_feira = 'Feira do Livro de Braga 2026';

-- Q4

SELECT titulo, data_hora, lotacao_max, inscritos, vagas_restantes, estado_vagas
FROM v_apresentacoes_disponiveis;

-- Q5

SELECT v.nome, v.email, v.telefone, ise.data_inscricao
FROM Inscreve_Sessao ise
JOIN Visitante v ON ise.id_visitante = v.id_visitante
WHERE ise.id_sessao = 1
  AND ise.estado = 'ativa';

-- Q6

SELECT livro, ISBN, stand, numero_stand, edicao_feira, quantidade
FROM v_livros_por_autor_na_feira
WHERE autor = 'Jose Saramago';

-- Q7

SELECT e.nome AS editora, COUNT(DISTINCT ss.id_livro) AS total_titulos
FROM Stand s
JOIN Editora e     ON s.id_editora = e.id_editora
JOIN StockStand ss ON s.id_stand   = ss.id_stand
JOIN Feira f       ON s.id_feira   = f.id_feira
WHERE f.nome = 'Feira do Livro de Braga 2026'
GROUP BY e.id_editora
ORDER BY total_titulos DESC
LIMIT 1;

-- Q8

SELECT bc.numero, bc.nome_comercial, bc.tipo_culinaria
FROM BarracaComida bc
JOIN Feira f ON bc.id_feira = f.id_feira
WHERE f.nome = 'Feira do Livro de Braga 2026';

-- Q9

SELECT l.genero, SUM(ss.quantidade) AS total_em_stock
FROM StockStand ss
JOIN Livro l ON ss.id_livro = l.id_livro
GROUP BY l.genero
ORDER BY total_em_stock DESC;

-- Q10

SELECT v.nome, v.email
FROM Inscreve_Feira inf
JOIN Visitante v ON inf.id_visitante = v.id_visitante
WHERE inf.estado = 'ativa'
  AND v.id_visitante NOT IN (
        SELECT id_visitante
        FROM Inscreve_Apresentacao
        WHERE estado = 'ativa'
  );


-- Q11
SELECT l.titulo, l.ISBN, s.nome_comercial AS stand,
       s.numero AS numero_stand, ss.quantidade
FROM Favorita fav
JOIN Livro l       ON fav.id_livro = l.id_livro
LEFT JOIN StockStand ss ON l.id_livro = ss.id_livro AND ss.quantidade > 0
LEFT JOIN Stand s  ON ss.id_stand = s.id_stand
JOIN Visitante v   ON fav.id_visitante = v.id_visitante
WHERE v.nome = 'Nome do Visitante';


-- Q12

SELECT livro, ISBN, stand, quantidade, preco_total, data_compra
FROM v_historico_compras_visitante
WHERE visitante = 'Nome do Visitante'
  AND edicao_feira = 'Feira do Livro de Braga 2026';
