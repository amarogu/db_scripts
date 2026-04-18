-- Criação dos utilizadores
CREATE USER 'admin_livros'@'localhost'   IDENTIFIED BY 'Admin@2026';
CREATE USER 'gestor_livros'@'localhost'  IDENTIFIED BY 'Gestor@2026';
CREATE USER 'consulta_livros'@'localhost' IDENTIFIED BY 'Consulta@2026';

-- admin_livros: acesso total à base de dados
GRANT ALL PRIVILEGES ON mydb.* TO 'admin_livros'@'localhost';

-- gestor_livros: pode consultar e modificar dados operacionais,
-- mas não pode alterar a estrutura da base de dados
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.Feira              TO 'gestor_livros'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.Stand              TO 'gestor_livros'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.BarracaComida      TO 'gestor_livros'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.Livro              TO 'gestor_livros'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.Autor              TO 'gestor_livros'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.Editora            TO 'gestor_livros'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.Livro_Autor        TO 'gestor_livros'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.StockStand         TO 'gestor_livros'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.Apresentacao       TO 'gestor_livros'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.SessaoAutografos   TO 'gestor_livros'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.Visitante          TO 'gestor_livros'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.Inscreve_Apresentacao TO 'gestor_livros'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.Inscreve_Sessao    TO 'gestor_livros'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.Inscreve_Feira     TO 'gestor_livros'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.Compra             TO 'gestor_livros'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.Favorita           TO 'gestor_livros'@'localhost';
GRANT SELECT                         ON mydb.Administrador     TO 'gestor_livros'@'localhost';
GRANT SELECT                         ON mydb.gere              TO 'gestor_livros'@'localhost';

-- consulta_livros: apenas leitura em todas as tabelas
GRANT SELECT ON mydb.* TO 'consulta_livros'@'localhost';

-- Aplicar as permissões
FLUSH PRIVILEGES;