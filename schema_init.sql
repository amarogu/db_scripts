SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8mb4 ;
USE `mydb` ;

-- Feira
CREATE TABLE IF NOT EXISTS `mydb`.`Feira` (
  `id_feira` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `data_inicio` DATE NOT NULL,
  `data_fim` DATE NOT NULL,
  `local` VARCHAR(100) NOT NULL,
  `cidade` VARCHAR(100) NOT NULL,
  `descricao` VARCHAR(200) NULL,
  PRIMARY KEY (`id_feira`))
ENGINE = InnoDB;


-- Editora
CREATE TABLE IF NOT EXISTS `mydb`.`Editora` (
  `id_editora` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `telefone` VARCHAR(20) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id_editora`))
ENGINE = InnoDB;


-- Autor
CREATE TABLE IF NOT EXISTS `mydb`.`Autor` (
  `id_autor` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `nacionalidade` VARCHAR(100) NOT NULL,
  `data_nascimento` DATE NOT NULL,
  `biografia` VARCHAR(200) NULL,
  PRIMARY KEY (`id_autor`))
ENGINE = InnoDB;


-- Livro
CREATE TABLE IF NOT EXISTS `mydb`.`Livro` (
  `id_livro` INT NOT NULL AUTO_INCREMENT,
  `ISBN` CHAR(13) NOT NULL,
  `titulo` VARCHAR(100) NOT NULL,
  `ano_publicacao` INT NOT NULL,
  `genero` SET('Romance','Aventura','Fantasia','Ficcao Cientifica','Terror','Drama','Ensaio','Poesia','Thriller','Historico','Infantil') NOT NULL,
  `preco` DECIMAL(5,2) NOT NULL,
  `id_editora` INT NULL,
  PRIMARY KEY (`id_livro`),
  INDEX `fk_livro_editora_idx` (`id_editora` ASC) VISIBLE,
  CONSTRAINT `fk_livro_editora`
    FOREIGN KEY (`id_editora`)
    REFERENCES `mydb`.`Editora` (`id_editora`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- Livro_Autor
CREATE TABLE IF NOT EXISTS `mydb`.`Livro_Autor` (
  `id_livro` INT NOT NULL,
  `id_autor` INT NOT NULL,
  PRIMARY KEY (`id_livro`, `id_autor`),
  INDEX `fk_livroautor_livro_idx` (`id_livro` ASC) VISIBLE,
  INDEX `fk_livroautor_autor_idx` (`id_autor` ASC) VISIBLE,
  CONSTRAINT `fk_livroautor_livro`
    FOREIGN KEY (`id_livro`)
    REFERENCES `mydb`.`Livro` (`id_livro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_livroautor_autor`
    FOREIGN KEY (`id_autor`)
    REFERENCES `mydb`.`Autor` (`id_autor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- Stand
CREATE TABLE IF NOT EXISTS `mydb`.`Stand` (
  `id_stand` INT NOT NULL AUTO_INCREMENT,
  `numero` INT NOT NULL,
  `nome_comercial` VARCHAR(100) NOT NULL,
  `area_m2` DECIMAL(6,2) NOT NULL,
  `localizacao` VARCHAR(100) NOT NULL,
  `id_feira` INT NOT NULL,
  `id_editora` INT NOT NULL,
  PRIMARY KEY (`id_stand`),
  INDEX `fk_stand_feira_idx` (`id_feira` ASC) VISIBLE,
  INDEX `fk_stand_editora_idx` (`id_editora` ASC) VISIBLE,
  CONSTRAINT `fk_stand_feira`
    FOREIGN KEY (`id_feira`)
    REFERENCES `mydb`.`Feira` (`id_feira`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_stand_editora`
    FOREIGN KEY (`id_editora`)
    REFERENCES `mydb`.`Editora` (`id_editora`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- StockStand
CREATE TABLE IF NOT EXISTS `mydb`.`StockStand` (
  `id_stand` INT NOT NULL,
  `id_livro` INT NOT NULL,
  `quantidade` INT NOT NULL,
  PRIMARY KEY (`id_stand`, `id_livro`),
  INDEX `fk_stockstand_stand_idx` (`id_stand` ASC) VISIBLE,
  INDEX `fk_stockstand_livro_idx` (`id_livro` ASC) VISIBLE,
  CONSTRAINT `fk_stockstand_stand`
    FOREIGN KEY (`id_stand`)
    REFERENCES `mydb`.`Stand` (`id_stand`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_stockstand_livro`
    FOREIGN KEY (`id_livro`)
    REFERENCES `mydb`.`Livro` (`id_livro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- BarracaComida
CREATE TABLE IF NOT EXISTS `mydb`.`BarracaComida` (
  `id_barraca_comida` INT NOT NULL AUTO_INCREMENT,
  `numero` INT NOT NULL,
  `nome_comercial` VARCHAR(100) NOT NULL,
  `tipo_culinaria` VARCHAR(100) NOT NULL,
  `id_feira` INT NOT NULL,
  PRIMARY KEY (`id_barraca_comida`),
  INDEX `fk_barracacomida_feira_idx` (`id_feira` ASC) VISIBLE,
  CONSTRAINT `fk_barracacomida_feira`
    FOREIGN KEY (`id_feira`)
    REFERENCES `mydb`.`Feira` (`id_feira`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- Apresentacao
CREATE TABLE IF NOT EXISTS `mydb`.`Apresentacao` (
  `id_apresentacao` INT NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(100) NOT NULL,
  `data_hora` DATETIME NOT NULL,
  `duracao_min` INT NOT NULL,
  `lotacao_max` INT NOT NULL,
  `sala` VARCHAR(100) NOT NULL,
  `estado_tempo` ENUM('agendada','a_decorrer','terminada') NOT NULL,
  `estado_vagas` ENUM('disponivel','esgotado') NOT NULL,
  `id_feira` INT NOT NULL,
  `id_livro` INT NOT NULL,
  `id_autor` INT NOT NULL,
  PRIMARY KEY (`id_apresentacao`),
  INDEX `fk_apresentacao_feira_idx` (`id_feira` ASC) VISIBLE,
  INDEX `fk_apresentacao_livro_idx` (`id_livro` ASC) VISIBLE,
  INDEX `fk_apresentacao_autor_idx` (`id_autor` ASC) VISIBLE,
  CONSTRAINT `fk_apresentacao_feira`
    FOREIGN KEY (`id_feira`)
    REFERENCES `mydb`.`Feira` (`id_feira`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_apresentacao_livro`
    FOREIGN KEY (`id_livro`)
    REFERENCES `mydb`.`Livro` (`id_livro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_apresentacao_autor`
    FOREIGN KEY (`id_autor`)
    REFERENCES `mydb`.`Autor` (`id_autor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- SessaoAutografos
CREATE TABLE IF NOT EXISTS `mydb`.`SessaoAutografos` (
  `id_sessao` INT NOT NULL AUTO_INCREMENT,
  `data_hora` DATETIME NOT NULL,
  `duracao_min` INT NOT NULL,
  `localizacao` VARCHAR(100) NOT NULL,
  `lotacao_max` INT NOT NULL,
  `estado_tempo` ENUM('agendada','a_decorrer','terminada') NOT NULL,
  `estado_vagas` ENUM('disponivel','esgotado') NOT NULL,
  `id_feira` INT NOT NULL,
  `id_autor` INT NOT NULL,
  PRIMARY KEY (`id_sessao`),
  INDEX `fk_sessao_feira_idx` (`id_feira` ASC) VISIBLE,
  INDEX `fk_sessao_autor_idx` (`id_autor` ASC) VISIBLE,
  CONSTRAINT `fk_sessao_feira`
    FOREIGN KEY (`id_feira`)
    REFERENCES `mydb`.`Feira` (`id_feira`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sessao_autor`
    FOREIGN KEY (`id_autor`)
    REFERENCES `mydb`.`Autor` (`id_autor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- Visitante
CREATE TABLE IF NOT EXISTS `mydb`.`Visitante` (
  `id_visitante` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `telefone` VARCHAR(20) NOT NULL,
  `NIF` VARCHAR(9) NOT NULL,
  PRIMARY KEY (`id_visitante`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `NIF_UNIQUE` (`NIF` ASC) VISIBLE)
ENGINE = InnoDB;


-- Administrador
CREATE TABLE IF NOT EXISTS `mydb`.`Administrador` (
  `id_administrador` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(100) NOT NULL,
  `nivel_acesso` VARCHAR(45) NOT NULL,
  `telefone` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id_administrador`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- Inscreve_Apresentacao
CREATE TABLE IF NOT EXISTS `mydb`.`Inscreve_Apresentacao` (
  `id_inscreve_apresentacao` INT NOT NULL AUTO_INCREMENT,
  `data_inscricao` DATE NOT NULL,
  `estado` ENUM('ativa','cancelada') NOT NULL,
  `id_visitante` INT NOT NULL,
  `id_apresentacao` INT NOT NULL,
  PRIMARY KEY (`id_inscreve_apresentacao`),
  UNIQUE INDEX `uk_inscricao_apresentacao` (`id_visitante` ASC, `id_apresentacao` ASC) VISIBLE,
  INDEX `fk_inscreve_apr_visitante_idx` (`id_visitante` ASC) VISIBLE,
  INDEX `fk_inscreve_apr_apresentacao_idx` (`id_apresentacao` ASC) VISIBLE,
  CONSTRAINT `fk_inscreve_apr_visitante`
    FOREIGN KEY (`id_visitante`)
    REFERENCES `mydb`.`Visitante` (`id_visitante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_inscreve_apr_apresentacao`
    FOREIGN KEY (`id_apresentacao`)
    REFERENCES `mydb`.`Apresentacao` (`id_apresentacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- Inscreve_Sessao
CREATE TABLE IF NOT EXISTS `mydb`.`Inscreve_Sessao` (
  `id_inscreve_sessao` INT NOT NULL AUTO_INCREMENT,
  `data_inscricao` DATE NOT NULL,
  `estado` ENUM('ativa','cancelada') NOT NULL,
  `id_visitante` INT NOT NULL,
  `id_sessao` INT NOT NULL,
  PRIMARY KEY (`id_inscreve_sessao`),
  UNIQUE INDEX `uk_inscricao_sessao` (`id_visitante` ASC, `id_sessao` ASC) VISIBLE,
  INDEX `fk_inscreve_ses_visitante_idx` (`id_visitante` ASC) VISIBLE,
  INDEX `fk_inscreve_ses_sessao_idx` (`id_sessao` ASC) VISIBLE,
  CONSTRAINT `fk_inscreve_ses_visitante`
    FOREIGN KEY (`id_visitante`)
    REFERENCES `mydb`.`Visitante` (`id_visitante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_inscreve_ses_sessao`
    FOREIGN KEY (`id_sessao`)
    REFERENCES `mydb`.`SessaoAutografos` (`id_sessao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- Inscreve_Feira
CREATE TABLE IF NOT EXISTS `mydb`.`Inscreve_Feira` (
  `id_inscreve_feira` INT NOT NULL AUTO_INCREMENT,
  `data_inscricao` DATE NOT NULL,
  `tipo_bilhete` VARCHAR(45) NOT NULL,
  `preco` DECIMAL(6,2) NOT NULL,
  `estado` ENUM('ativa','cancelada') NOT NULL,
  `id_visitante` INT NOT NULL,
  `id_feira` INT NOT NULL,
  PRIMARY KEY (`id_inscreve_feira`),
  UNIQUE INDEX `uk_inscricao_feira` (`id_visitante` ASC, `id_feira` ASC) VISIBLE,
  INDEX `fk_inscreve_fei_visitante_idx` (`id_visitante` ASC) VISIBLE,
  INDEX `fk_inscreve_fei_feira_idx` (`id_feira` ASC) VISIBLE,
  CONSTRAINT `fk_inscreve_fei_visitante`
    FOREIGN KEY (`id_visitante`)
    REFERENCES `mydb`.`Visitante` (`id_visitante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_inscreve_fei_feira`
    FOREIGN KEY (`id_feira`)
    REFERENCES `mydb`.`Feira` (`id_feira`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- gere
CREATE TABLE IF NOT EXISTS `mydb`.`gere` (
  `id_administrador` INT NOT NULL,
  `id_feira` INT NOT NULL,
  `data_inicio_gestao` DATE NOT NULL,
  `cargo` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id_administrador`, `id_feira`),
  INDEX `fk_gere_feira_idx` (`id_feira` ASC) VISIBLE,
  INDEX `fk_gere_administrador_idx` (`id_administrador` ASC) VISIBLE,
  CONSTRAINT `fk_gere_feira`
    FOREIGN KEY (`id_feira`)
    REFERENCES `mydb`.`Feira` (`id_feira`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_gere_administrador`
    FOREIGN KEY (`id_administrador`)
    REFERENCES `mydb`.`Administrador` (`id_administrador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- Compra
CREATE TABLE IF NOT EXISTS `mydb`.`Compra` (
  `id_compra` INT NOT NULL AUTO_INCREMENT,
  `data_compra` DATETIME NOT NULL,
  `quantidade` INT NOT NULL,
  `preco_total` DECIMAL(8,2) NOT NULL,
  `id_visitante` INT NOT NULL,
  `id_stand` INT NOT NULL,
  `id_livro` INT NOT NULL,
  PRIMARY KEY (`id_compra`),
  INDEX `fk_compra_visitante_idx` (`id_visitante` ASC) VISIBLE,
  INDEX `fk_compra_stand_idx` (`id_stand` ASC) VISIBLE,
  INDEX `fk_compra_livro_idx` (`id_livro` ASC) VISIBLE,
  CONSTRAINT `fk_compra_visitante`
    FOREIGN KEY (`id_visitante`)
    REFERENCES `mydb`.`Visitante` (`id_visitante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_compra_stand`
    FOREIGN KEY (`id_stand`)
    REFERENCES `mydb`.`Stand` (`id_stand`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_compra_livro`
    FOREIGN KEY (`id_livro`)
    REFERENCES `mydb`.`Livro` (`id_livro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- Favorita
CREATE TABLE IF NOT EXISTS `mydb`.`Favorita` (
  `id_visitante` INT NOT NULL,
  `id_livro` INT NOT NULL,
  `id_stand` INT NULL,
  `data_favoritado` DATE NOT NULL,
  PRIMARY KEY (`id_visitante`, `id_livro`),
  INDEX `fk_favorita_visitante_idx` (`id_visitante` ASC) VISIBLE,
  INDEX `fk_favorita_livro_idx` (`id_livro` ASC) VISIBLE,
  INDEX `fk_favorita_stand_idx` (`id_stand` ASC) VISIBLE,
  CONSTRAINT `fk_favorita_visitante`
    FOREIGN KEY (`id_visitante`)
    REFERENCES `mydb`.`Visitante` (`id_visitante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_favorita_livro`
    FOREIGN KEY (`id_livro`)
    REFERENCES `mydb`.`Livro` (`id_livro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_favorita_stand`
    FOREIGN KEY (`id_stand`)
    REFERENCES `mydb`.`Stand` (`id_stand`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
