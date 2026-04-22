USE mydb;

-- Q1
SELECT stand, numero_stand, quantidade
FROM v_stock_livros_stands
WHERE Titulo = 'Nome do Livro'
   OR ISBN = '9789720706530';

-- Q2

SELECT titulo, data_hora, lotação_max, estado_vagas
FROM Apresentação
WHERE DATE(data_hora) = '2026-06-15';

-- Q3

SELECT autor, data_hora, localização, estado_vaga
FROM v_sessoes_autografos_por_edicao
WHERE edicao_feira = 'Feira do Livro de Braga 2026';

-- Q4

SELECT titulo, data_hora, lotação_max, inscritos, vagas_restantes, estado_vagas
FROM v_apresentacoes_disponiveis;

-- Q5

SELECT v.nome, v.email, v.telefone, ise.Data_inscriçao
FROM Inscreve_Sessao ise
JOIN Visitante v ON ise.id_increve_sessao_visitante = v.id_Visitante
WHERE ise.id_sessao_inscreve = 1
  AND ise.estado = 'ativa';

-- Q6

SELECT livro, ISBN, stand, numero_stand, edicao_feira, quantidade
FROM v_livros_por_autor_na_feira
WHERE autor = 'José Saramago';

-- Q7

SELECT e.nome AS editora, COUNT(DISTINCT ss.id_livro) AS total_titulos
FROM Stand s
JOIN Editora e ON s.id_editora = e.id_Editora
JOIN StockStand ss ON s.id_Stand = ss.id_Stand
JOIN Feira f ON s.id_feira = f.id_Feira
WHERE f.nome = 'Feira do Livro de Braga 2026'
GROUP BY e.id_Editora
ORDER BY total_titulos DESC
LIMIT 1;

-- Q8

SELECT bc.numero, bc.nome_comercial, bc.tipo_culinaria
FROM BarracaComida bc
JOIN Feira f ON bc.id_feira_barracacomida = f.id_Feira
WHERE f.nome = 'Feira do Livro de Braga 2026';

-- Q9

SELECT l.genero, SUM(ss.quantidade) AS total_em_stock
FROM StockStand ss
JOIN Livro l ON ss.id_livro = l.id_Livro
GROUP BY l.genero
ORDER BY total_em_stock DESC;

-- Q10

SELECT v.nome, v.email
FROM Inscreve_Feira inf
JOIN Visitante v ON inf.id_increve_feira_visitante = v.id_Visitante
WHERE inf.estado = 'ativada'
AND v.id_Visitante NOT IN (
	SELECT id_visitante_increve
    FROM Inscreve_Apresentação
    WHERE estado = 'ativa' );


-- Q11
SELECT l.Titulo, l.ISBN, s.nome_comercial AS stand,
       s.numero AS numero_stand, ss.quantidade
FROM Favorita fav
JOIN Livro l ON fav.id_livro = l.id_Livro
LEFT JOIN StockStand ss ON l.id_Livro = ss.id_livro AND ss.quantidade > 0
LEFT JOIN Stand s ON ss.id_Stand = s.id_Stand
JOIN Visitante v ON fav.id_visitante = v.id_Visitante
WHERE v.nome = 'Nome do Visitante';


-- Q12

SELECT livro, ISBN, stand, quantidade, preço_total, data_compra
FROM v_historico_compras_visitante
WHERE visitante = 'Nome do Visitante'
  AND edicao_feira = 'Feira do Livro de Braga 2026';
