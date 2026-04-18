USE mydb;
ALTER TABLE mydb.Feira             MODIFY id_Feira INT NOT NULL AUTO_INCREMENT;
ALTER TABLE mydb.Editora           MODIFY id_Editora INT NOT NULL AUTO_INCREMENT;
ALTER TABLE mydb.Autor             MODIFY id_Autor INT NOT NULL AUTO_INCREMENT;
ALTER TABLE mydb.Livro             MODIFY id_Livro INT NOT NULL AUTO_INCREMENT;
ALTER TABLE mydb.Stand             MODIFY id_Stand INT NOT NULL AUTO_INCREMENT;
ALTER TABLE mydb.BarracaComida     MODIFY id_BarracaComida INT NOT NULL AUTO_INCREMENT;
ALTER TABLE mydb.Apresentacao      MODIFY id_Apresentacao INT NOT NULL AUTO_INCREMENT;
ALTER TABLE mydb.SessaoAutografos  MODIFY id_SessaoAutografos INT NOT NULL AUTO_INCREMENT;
ALTER TABLE mydb.Visitante         MODIFY id_Visitante INT NOT NULL AUTO_INCREMENT;
ALTER TABLE mydb.Administrador     MODIFY id_Administrador INT NOT NULL AUTO_INCREMENT;
ALTER TABLE mydb.Inscreve_Apresentacao MODIFY id_Inscreve_Apresentacao INT NOT NULL AUTO_INCREMENT;
ALTER TABLE mydb.Inscreve_Sessao   MODIFY id_Inscreve_Sessao INT NOT NULL AUTO_INCREMENT;
ALTER TABLE mydb.Inscreve_Feira    MODIFY id_Inscreve_Feira INT NOT NULL AUTO_INCREMENT;
ALTER TABLE mydb.Compra            MODIFY id_Compra INT NOT NULL AUTO_INCREMENT;

-- -----------------------------------------------------
-- Feira
-- -----------------------------------------------------
INSERT INTO Feira (nome, data_inicio, data_fim, local, cidade, descrição) VALUES
('Feira do Livro de Braga 2026', '2026-05-01', '2026-05-15', 'Parque da Ponte', 'Braga', 'Edição anual da Feira do Livro de Braga'),
('Feira do Livro do Porto 2026', '2026-06-01', '2026-06-20', 'Parque da Cidade', 'Porto', 'Edição anual da Feira do Livro do Porto'),
('Feira do Livro de Lisboa 2026', '2026-05-30', '2026-06-15', 'Parque Eduardo VII', 'Lisboa', 'Maior feira do livro de Portugal');

-- -----------------------------------------------------
-- Editora
-- -----------------------------------------------------
INSERT INTO Editora (nome, telefone, email) VALUES
('Porto Editora', '222111000', 'geral@portoeditora.pt'),
('Leya', '213456789', 'geral@leya.com'),
('Bertrand', '213654321', 'geral@bertrand.pt'),
('Almedina', '239851904', 'geral@almedina.net'),
('Planeta', '213210000', 'geral@planeta.pt');

-- -----------------------------------------------------
-- Autor
-- -----------------------------------------------------
INSERT INTO Autor (nome, nacionalidade, data_nascimento, biografia) VALUES
('Jose Saramago', 'Portuguesa', '1922-11-16', 'Nobel da Literatura em 1998, autor de O Evangelho Segundo Jesus Cristo.'),
('Eca de Queiros', 'Portuguesa', '1845-11-25', 'Um dos maiores escritores do realismo portugues.'),
('Fernando Pessoa', 'Portuguesa', '1888-06-13', 'Poeta portugues, criador de varios heteronimos.'),
('Agatha Christie', 'Britanica', '1890-09-15', 'Rainha do crime, autora de mais de 60 romances policiais.'),
('George Orwell', 'Britanica', '1903-06-25', 'Autor de 1984 e A Quinta dos Animais.'),
('Joao Tordo', 'Portuguesa', '1975-03-10', 'Escritor portugues contemporaneo, autor de O Paraiso Perdido.'),
('Lidia Jorge', 'Portuguesa', '1946-06-18', 'Escritora portuguesa, autora de A Costa dos Murmurios.');

-- -----------------------------------------------------
-- Livro
-- -----------------------------------------------------
INSERT INTO Livro (ISBN, Titulo, ano_publicação, genero, Preço, id_livro_editora) VALUES
('9789722009098', 'O Evangelho Segundo Jesus Cristo', 1991, 'Romance', 14.90, 1),
('9789722033466', 'Ensaio sobre a Cegueira', 1995, 'Romance', 13.50, 1),
('9789897222836', 'Os Maias', 1888, 'Romance,Historico', 12.00, 2),
('9789720419637', 'Livro do Desassossego', 1982, 'Poesia,Ensaio', 15.90, 3),
('9789722325461', '1984', 1949, 'Ficcao Cientifica,Terror', 11.50, 2),
('9789897011234', 'A Quinta dos Animais', 1945, 'Fantasia', 9.90, 2),
('9789722044512', 'Assassinato no Expresso do Oriente', 1934, 'Thriller', 10.50, 3),
('9789722098765', 'O Paraiso Perdido', 2011, 'Romance', 16.00, 4),
('9789897054321', 'A Costa dos Murmurios', 1988, 'Romance,Historico', 13.00, 4),
('9789720001122', 'Dez Negrinhos', 1939, 'Thriller', 10.00, 3);

-- -----------------------------------------------------
-- Livro_Autor
-- -----------------------------------------------------
INSERT INTO Livro_Autor (id_livro, id_autor) VALUES
(1, 1),  -- O Evangelho -> Saramago
(2, 1),  -- Ensaio -> Saramago
(3, 2),  -- Os Maias -> Eca
(4, 3),  -- Desassossego -> Pessoa
(5, 5),  -- 1984 -> Orwell
(6, 5),  -- Quinta Animais -> Orwell
(7, 4),  -- Assassinato -> Christie
(8, 6),  -- Paraiso -> Tordo
(9, 7),  -- Costa Murmurios -> Lidia Jorge
(10, 4); -- Dez Negrinhos -> Christie

-- -----------------------------------------------------
-- Stand
-- -----------------------------------------------------
INSERT INTO Stand (numero, nome_comercial, area_m2, localização, id_stand_feira, id_stand_editora) VALUES
(1, 'Porto Editora Braga', 30.00, 'Zona A - Entrada Principal', 1, 1),
(2, 'Leya Braga', 25.00, 'Zona A - Lateral Esquerda', 1, 2),
(3, 'Bertrand Braga', 20.00, 'Zona B - Centro', 1, 3),
(4, 'Porto Editora Porto', 35.00, 'Zona Principal', 2, 1),
(5, 'Almedina Porto', 28.00, 'Zona B - Fundo', 2, 4),
(6, 'Planeta Lisboa', 40.00, 'Zona Central', 3, 5),
(7, 'Bertrand Lisboa', 30.00, 'Zona Norte', 3, 3);

-- -----------------------------------------------------
-- StockStand
-- -----------------------------------------------------
INSERT INTO StockStand (id_Stand, id_livro, quantidade) VALUES
(1, 1, 20), (1, 2, 15), (1, 3, 10),
(2, 3, 12), (2, 5, 8),  (2, 6, 10),
(3, 7, 15), (3, 10, 20),
(4, 1, 25), (4, 2, 18), (4, 4, 10),
(5, 8, 12), (5, 9, 14),
(6, 5, 20), (6, 6, 15), (6, 7, 18),
(7, 9, 10), (7, 10, 12);

-- -----------------------------------------------------
-- BarracaComida
-- -----------------------------------------------------
INSERT INTO BarracaComida (numero, nome_comercial, tipo_culinaria, id_feira_barracacomida) VALUES
(1, 'Tasca do Ze', 'Portuguesa', 1),
(2, 'Pizza Express', 'Italiana', 1),
(3, 'O Bifanas', 'Portuguesa', 2),
(4, 'Sushi Garden', 'Japonesa', 2),
(5, 'A Churrasqueira', 'Portuguesa', 3),
(6, 'Crepes & Cia', 'Francesa', 3);

-- -----------------------------------------------------
-- Apresentacao
-- -----------------------------------------------------
INSERT INTO Apresentação (titulo, sala, data_hora, duração_min, lotação_max, estado_tempo, estado_vagas, id_apresentação_feira, id_apresentação_livro, id_apresentação_autor) VALUES
('Ensaio sobre a Cegueira - 30 anos depois', 'Sala A', '2026-05-03 15:00:00', 60, 50, 'agendada', 'disponivel', 1, 2, 1),
('Os Maias - Uma releitura contemporanea', 'Sala B', '2026-05-05 17:00:00', 45, 30, 'agendada', 'disponivel', 1, 3, 2),
('Apresentacao de O Paraiso Perdido', 'Auditorio', '2026-06-03 18:00:00', 60, 80, 'agendada', 'disponivel', 2, 8, 6),
('A Costa dos Murmurios em Lisboa', 'Sala Principal', '2026-05-31 16:00:00', 50, 60, 'agendada', 'disponivel', 3, 9, 7),
('1984 - Relevancia nos dias de hoje', 'Sala B', '2026-06-10 19:00:00', 75, 40, 'agendada', 'disponivel', 3, 5, 5);

-- -----------------------------------------------------
-- SessaoAutografos
-- -----------------------------------------------------
INSERT INTO SessaoAutografos (data_hora, duracao_min, localizacao, lotacao_max, estado_tempo, estado_vaga, id_sessao_feira, id_sessao_autor) VALUES
('2026-05-03 17:00:00', 60, 'Stand Porto Editora - Zona A', 30, 'agendada', 'disponivel', 1, 1),
('2026-05-06 16:00:00', 45, 'Stand Leya - Zona A', 20, 'agendada', 'disponivel', 1, 2),
('2026-06-04 17:30:00', 60, 'Stand Almedina - Zona B', 25, 'agendada', 'disponivel', 2, 6),
('2026-06-01 15:00:00', 90, 'Tenda dos Autores', 40, 'agendada', 'disponivel', 3, 7),
('2026-06-12 18:00:00', 60, 'Stand Planeta - Zona Central', 30, 'agendada', 'disponivel', 3, 5);

-- -----------------------------------------------------
-- Visitante
-- -----------------------------------------------------
INSERT INTO Visitante (nome, email, telefone, NIF) VALUES
('Ana Silva', 'ana.silva@email.pt', '912345678', '123456789'),
('Bruno Costa', 'bruno.costa@email.pt', '923456789', '234567890'),
('Carla Mendes', 'carla.mendes@email.pt', '934567890', '345678901'),
('David Ferreira', 'david.ferreira@email.pt', '945678901', '456789012'),
('Elena Santos', 'elena.santos@email.pt', '956789012', '567890123'),
('Francisco Oliveira', 'francisco.oliveira@email.pt', '967890123', '678901234'),
('Goncalo Pereira', 'goncalo.pereira@email.pt', '978901234', '789012345');

-- -----------------------------------------------------
-- Administrador
-- -----------------------------------------------------
INSERT INTO Administrador (nome, email, password, nivel_acesso, telefone) VALUES
('Maria Administradora', 'maria.admin@livros.pt', SHA2('Admin2026!', 256), 'admin', '210000001'),
('Pedro Gestor', 'pedro.gestor@livros.pt', SHA2('Gestor2026!', 256), 'gestor', '210000002'),
('Sofia Auxiliar', 'sofia.aux@livros.pt', SHA2('Aux2026!', 256), 'auxiliar', '210000003');

-- -----------------------------------------------------
-- Inscreve_Feira
-- -----------------------------------------------------
INSERT INTO Inscreve_Feira (data_inscricao, tipo_bilhete, preco, estado, id_increve_feira_visitante, id_increve_feira) VALUES
('2026-04-10', 'Pago', 5.00, 'ativa', 1, 1),
('2026-04-11', 'Pago', 5.00, 'ativa', 2, 1),
('2026-04-12', 'Gratuito', 0.00, 'ativa', 3, 1),
('2026-05-15', 'Pago', 5.00, 'ativa', 1, 2),
('2026-05-16', 'Pago', 5.00, 'ativa', 4, 2),
('2026-05-01', 'Pago', 5.00, 'ativa', 5, 3),
('2026-05-02', 'Gratuito', 0.00, 'ativa', 6, 3);

-- -----------------------------------------------------
-- Inscreve_Apresentacao
-- -----------------------------------------------------
INSERT INTO Inscreve_Apresentacao (data_inscricao, estado, id_visitante_increve, id_increve_apresentacao) VALUES
('2026-04-20', 'ativa', 1, 1),
('2026-04-21', 'ativa', 2, 1),
('2026-04-22', 'ativa', 3, 1),
('2026-04-23', 'ativa', 1, 2),
('2026-05-20', 'ativa', 4, 3),
('2026-05-10', 'ativa', 5, 4),
('2026-05-11', 'ativa', 6, 4),
('2026-05-12', 'cancelada', 5, 5);

-- -----------------------------------------------------
-- Inscreve_Sessao
-- -----------------------------------------------------
INSERT INTO Inscreve_Sessao (data_inscricao, estado, id_increve_sessao_visitante, id_sessao_inscreve) VALUES
('2026-04-20', 'ativa', 1, 1),
('2026-04-21', 'ativa', 2, 1),
('2026-04-22', 'ativa', 3, 2),
('2026-05-20', 'ativa', 4, 3),
('2026-05-10', 'ativa', 5, 4),
('2026-05-11', 'ativa', 6, 4),
('2026-05-12', 'ativa', 7, 5);

-- -----------------------------------------------------
-- gere
-- -----------------------------------------------------
INSERT INTO gere (id_admin, id_feira, data_inicio_gestao, cargo) VALUES
(1, 1, '2026-01-10', 'Coordenador'),
(1, 3, '2026-01-15', 'Coordenador'),
(2, 1, '2026-02-01', 'Assistente'),
(2, 2, '2026-02-01', 'Coordenador'),
(3, 2, '2026-02-15', 'Assistente');

-- -----------------------------------------------------
-- Compra
-- -----------------------------------------------------
INSERT INTO Compra (data_compra, quantidade, preco_total, id_visitante, id_stand, id_livro) VALUES
('2026-05-02 10:30:00', 1, 14.90, 1, 1, 1),
('2026-05-02 11:00:00', 2, 27.00, 2, 1, 2),
('2026-05-03 14:00:00', 1, 12.00, 3, 2, 3),
('2026-05-03 15:30:00', 1, 11.50, 1, 2, 5),
('2026-06-02 10:00:00', 1, 16.00, 4, 5, 8),
('2026-05-31 16:00:00', 1, 13.00, 5, 7, 9),
('2026-06-11 17:00:00', 2, 21.00, 6, 6, 7);

-- -----------------------------------------------------
-- Favorita
-- -----------------------------------------------------
INSERT INTO Favorita (id_visitante, id_livro, id_stand, data_favoritado) VALUES
(1, 3, 2, '2026-05-02'),
(1, 7, 3, '2026-05-03'),
(2, 1, 1, '2026-05-02'),
(3, 5, 2, '2026-05-03'),
(4, 8, 5, '2026-06-02'),
(5, 9, 7, '2026-05-31'),
(6, 10, 7, '2026-06-01');