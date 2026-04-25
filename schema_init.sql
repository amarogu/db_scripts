-- MySQL Workbench Forward Engineering

-- begin attached script 'script'
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Feira`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Feira` (
  `id_Feira` INT NOT NULL DEFAULT 0,
  `nome` VARCHAR(100) NOT NULL,
  `data_inicio` DATE NOT NULL,
  `data_fim` DATE NOT NULL,
  `local` VARCHAR(100) NOT NULL,
  `cidade` VARCHAR(100) NOT NULL,
  `descrição` VARCHAR(100) NULL,
  PRIMARY KEY (`id_Feira`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Editora`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Editora` (
  `id_Editora` INT NOT NULL DEFAULT 0,
  `nome` VARCHAR(45) NOT NULL,
  `telefone` VARCHAR(20) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id_Editora`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Autor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Autor` (
  `id_Autor` INT NOT NULL DEFAULT 0,
  `nome` VARCHAR(100) NOT NULL,
  `nacionalidade` VARCHAR(100) NOT NULL,
  `data_nascimento` DATE NOT NULL,
  `biografia` VARCHAR(200) NULL,
  PRIMARY KEY (`id_Autor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Livro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Livro` (
  `id_Livro` INT NOT NULL DEFAULT 0,
  `ISBN` CHAR(13) NOT NULL,
  `Titulo` VARCHAR(100) NOT NULL,
  `ano_publicação` INT NOT NULL,
  `genero` SET('Romance', 'Aventura', 'Fantasia', 'ficção Científica', 'Terror', 'Drama', 'Ensaio', 'Poesia', 'Thriller', 'Histórico', 'Infantil') NOT NULL,
  `Preço` DECIMAL(5,2) NOT NULL,
  `id_livro_editora` INT NULL,
  PRIMARY KEY (`id_Livro`),
  INDEX `id_editora_idx` (`id_livro_editora` ASC) VISIBLE,
  CONSTRAINT `fk_livro_editora`
    FOREIGN KEY (`id_livro_editora`)
    REFERENCES `mydb`.`Editora` (`id_Editora`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Livro_Autor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Livro_Autor` (
  `id_livro` INT NOT NULL,
  `id_autor` INT NOT NULL,
  INDEX `id_livro_idx` (`id_livro` ASC) VISIBLE,
  INDEX `id_autor_idx` (`id_autor` ASC) VISIBLE,
  CONSTRAINT `fk_livroautor_livro`
    FOREIGN KEY (`id_livro`)
    REFERENCES `mydb`.`Livro` (`id_Livro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_livroautor_autor`
    FOREIGN KEY (`id_autor`)
    REFERENCES `mydb`.`Autor` (`id_Autor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Stand`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Stand` (
  `id_Stand` INT NOT NULL DEFAULT 0,
  `numero` INT NOT NULL,
  `nome_comercial` VARCHAR(100) NOT NULL,
  `area_m2` DECIMAL(6,2) NOT NULL,
  `localização` VARCHAR(100) NOT NULL,
  `id_stand_feira` INT NOT NULL,
  `id_stand_editora` INT NOT NULL,
  PRIMARY KEY (`id_Stand`),
  INDEX `feira_idx` (`id_stand_feira` ASC) VISIBLE,
  INDEX `editora_idx` (`id_stand_editora` ASC) VISIBLE,
  CONSTRAINT `fk_stand_feira`
    FOREIGN KEY (`id_stand_feira`)
    REFERENCES `mydb`.`Feira` (`id_Feira`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_stand_editora`
    FOREIGN KEY (`id_stand_editora`)
    REFERENCES `mydb`.`Editora` (`id_Editora`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`StockStand`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`StockStand` (
  `id_Stand` INT NOT NULL,
  `id_livro` INT NOT NULL,
  `quantidade` INT NOT NULL,
  INDEX `stand_idx` (`id_Stand` ASC) VISIBLE,
  INDEX `livro_idx` (`id_livro` ASC) VISIBLE,
  CONSTRAINT `fk_stockstand_stand`
    FOREIGN KEY (`id_Stand`)
    REFERENCES `mydb`.`Stand` (`id_Stand`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_staockstand_livro`
    FOREIGN KEY (`id_livro`)
    REFERENCES `mydb`.`Livro` (`id_Livro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`BarracaComida`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`BarracaComida` (
  `id_BarracaComida` INT NOT NULL DEFAULT 0,
  `numero` INT NOT NULL,
  `nome_comercial` VARCHAR(100) NOT NULL,
  `tipo_culinaria` VARCHAR(100) NOT NULL,
  `id_feira_barracacomida` INT NOT NULL,
  PRIMARY KEY (`id_BarracaComida`),
  INDEX `feira_idx` (`id_feira_barracacomida` ASC) VISIBLE,
  CONSTRAINT `fk_barracacomida_feira`
    FOREIGN KEY (`id_feira_barracacomida`)
    REFERENCES `mydb`.`Feira` (`id_Feira`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Apresentação`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Apresentação` (
  `id_Apresentação` INT NOT NULL DEFAULT 0,
  `titulo` VARCHAR(100) NOT NULL,
  `data_hora` DATETIME NOT NULL,
  `duração_min` INT NOT NULL,
  `lotação_max` INT NOT NULL,
  `sala` VARCHAR(100) NOT NULL,
  `estado_tempo` ENUM('agendada', 'a decorrer', ' terminada') NOT NULL,
  `estado_vagas` ENUM('disponível', ' esgotado') NOT NULL,
  `id_apresentação_feira` INT NOT NULL,
  `id_apresentação_livro` INT NOT NULL,
  `id_apresentação_autor` INT NOT NULL,
  PRIMARY KEY (`id_Apresentação`),
  INDEX `feira_idx` (`id_apresentação_feira` ASC) VISIBLE,
  INDEX `livro_idx` (`id_apresentação_livro` ASC) VISIBLE,
  INDEX `autor_idx` (`id_apresentação_autor` ASC) VISIBLE,
  CONSTRAINT `fk_apresentaçao_feira`
    FOREIGN KEY (`id_apresentação_feira`)
    REFERENCES `mydb`.`Feira` (`id_Feira`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_apresentaçao_livro`
    FOREIGN KEY (`id_apresentação_livro`)
    REFERENCES `mydb`.`Livro` (`id_Livro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_apresentação_autor`
    FOREIGN KEY (`id_apresentação_autor`)
    REFERENCES `mydb`.`Autor` (`id_Autor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`SessaoAutografos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`SessaoAutografos` (
  `id_SessaoAutografos` INT NOT NULL DEFAULT 0,
  `data_hora` DATETIME NOT NULL,
  `duraçao_min` INT NOT NULL,
  `localização` VARCHAR(100) NOT NULL,
  `lotaçao_max` INT NOT NULL,
  `estado_tempo` ENUM('agendada', 'a decorrer', ' terminada') NOT NULL,
  `estado_vaga` ENUM('disponível', ' esgotado') NOT NULL,
  `id_sessao_feira` INT NOT NULL,
  `id_sessao_autor` INT NOT NULL,
  PRIMARY KEY (`id_SessaoAutografos`),
  INDEX `feira_idx` (`id_sessao_feira` ASC) VISIBLE,
  INDEX `autor_idx` (`id_sessao_autor` ASC) VISIBLE,
  CONSTRAINT `fk_sessao_feira`
    FOREIGN KEY (`id_sessao_feira`)
    REFERENCES `mydb`.`Feira` (`id_Feira`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sessao_autor`
    FOREIGN KEY (`id_sessao_autor`)
    REFERENCES `mydb`.`Autor` (`id_Autor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Visitante`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Visitante` (
  `id_Visitante` INT NOT NULL DEFAULT 0,
  `nome` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `telefone` VARCHAR(20) NOT NULL,
  `NIF` VARCHAR(9) NOT NULL,
  PRIMARY KEY (`id_Visitante`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `NIF_UNIQUE` (`NIF` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Administrador`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Administrador` (
  `id_Administrador` INT NOT NULL DEFAULT 0,
  `nome` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(100) NOT NULL,
  `nivel_acesso` VARCHAR(45) NOT NULL,
  `telefone` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id_Administrador`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Inscreve_Apresentação`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Inscreve_Apresentação` (
  `id_Inscreve_Apresentação` INT NOT NULL DEFAULT 0,
  `data_incriçao` DATE NOT NULL,
  `estado` ENUM('ativa', 'cancelada') NOT NULL,
  `id_visitante_increve` INT NOT NULL,
  `id_increve_apresentaçao` INT NOT NULL,
  PRIMARY KEY (`id_Inscreve_Apresentação`),
  UNIQUE INDEX `id_visitante_UNIQUE` (`id_visitante_increve` ASC) VISIBLE,
  UNIQUE INDEX `id_apresentaçao_UNIQUE` (`id_increve_apresentaçao` ASC) VISIBLE,
  CONSTRAINT `fk_inscreve_apresentaçao_visitante`
    FOREIGN KEY (`id_visitante_increve`)
    REFERENCES `mydb`.`Visitante` (`id_Visitante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_increve__apresentaçao_apresentaçao`
    FOREIGN KEY (`id_increve_apresentaçao`)
    REFERENCES `mydb`.`Apresentação` (`id_Apresentação`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Inscreve_Sessao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Inscreve_Sessao` (
  `id_Inscreve_Sessao` INT NOT NULL DEFAULT 0,
  `Data_inscriçao` DATE NOT NULL,
  `estado` ENUM('ativa', 'cancelada') NOT NULL,
  `id_increve_sessao_visitante` INT NOT NULL,
  `id_sessao_inscreve` INT NOT NULL,
  PRIMARY KEY (`id_Inscreve_Sessao`),
  UNIQUE INDEX `id_visitante_UNIQUE` (`id_increve_sessao_visitante` ASC) VISIBLE,
  UNIQUE INDEX `id_sessao_UNIQUE` (`id_sessao_inscreve` ASC) VISIBLE,
  CONSTRAINT `fk_increve_sessao_visitante`
    FOREIGN KEY (`id_increve_sessao_visitante`)
    REFERENCES `mydb`.`Visitante` (`id_Visitante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_increve_ sessao_sessao`
    FOREIGN KEY (`id_sessao_inscreve`)
    REFERENCES `mydb`.`SessaoAutografos` (`id_SessaoAutografos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Inscreve_Feira`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Inscreve_Feira` (
  `id_Inscreve_Feira` INT NOT NULL DEFAULT 0,
  `Data_inscriçao` DATE NOT NULL,
  `tipo_bilhete` VARCHAR(45) NOT NULL,
  `preço` DECIMAL(3,2) NOT NULL,
  `estado` ENUM('ativada', 'cancelada') NOT NULL,
  `id_increve_feira_visitante` INT NOT NULL,
  `id_increve_feira` INT NOT NULL,
  PRIMARY KEY (`id_Inscreve_Feira`),
  UNIQUE INDEX `id_visitante_UNIQUE` (`id_increve_feira_visitante` ASC) VISIBLE,
  UNIQUE INDEX `id_feira_UNIQUE` (`id_increve_feira` ASC) VISIBLE,
  CONSTRAINT `fk_increve_feira_visitante`
    FOREIGN KEY (`id_increve_feira_visitante`)
    REFERENCES `mydb`.`Visitante` (`id_Visitante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_inscreve_feira_feira`
    FOREIGN KEY (`id_increve_feira`)
    REFERENCES `mydb`.`Feira` (`id_Feira`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`gere`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`gere` (
  `id_admin` INT NOT NULL,
  `id_feira` INT NOT NULL,
  `data_inicio_gestao` INT NOT NULL,
  `cargo` VARCHAR(100) NOT NULL,
  INDEX `feira_idx` (`id_feira` ASC) VISIBLE,
  INDEX `Administrador_idx` (`id_admin` ASC) VISIBLE,
  CONSTRAINT `fk_gere_feira`
    FOREIGN KEY (`id_feira`)
    REFERENCES `mydb`.`Feira` (`id_Feira`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_gere_Administrador`
    FOREIGN KEY (`id_admin`)
    REFERENCES `mydb`.`Administrador` (`id_Administrador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Compra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Compra` (
  `id_Compra` INT NOT NULL DEFAULT 0,
  `data_compra` DATE NOT NULL,
  `quantidade` INT NOT NULL,
  `preço_total` DECIMAL(8,2) NOT NULL,
  `id_visitante` INT NOT NULL,
  `id_stand` INT NOT NULL,
  `id_livro` INT NOT NULL,
  PRIMARY KEY (`id_Compra`),
  INDEX `fk_visitante_compra_idx` (`id_visitante` ASC) VISIBLE,
  INDEX `fk_stand_compra_idx` (`id_stand` ASC) VISIBLE,
  INDEX `fk_livro_compra_idx` (`id_livro` ASC) VISIBLE,
  CONSTRAINT `fk_visitante_compra`
    FOREIGN KEY (`id_visitante`)
    REFERENCES `mydb`.`Visitante` (`id_Visitante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_stand_compra`
    FOREIGN KEY (`id_stand`)
    REFERENCES `mydb`.`Stand` (`id_Stand`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_livro_compra`
    FOREIGN KEY (`id_livro`)
    REFERENCES `mydb`.`Livro` (`id_Livro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Favorita`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Favorita` (
  `id_visitante` INT NOT NULL DEFAULT 0,
  `id_livro` INT NOT NULL DEFAULT 0,
  `id_stand` INT NULL,
  `data_favoritado` DATE NOT NULL,
  INDEX `id_visitante_favoritado_idx` (`id_visitante` ASC) VISIBLE,
  INDEX `id_livro_favoritado_idx` (`id_livro` ASC) VISIBLE,
  INDEX `id_livro_stand_idx` (`id_stand` ASC) VISIBLE,
  PRIMARY KEY (`id_visitante`, `id_livro`),
  CONSTRAINT `id_visitante_favoritado`
    FOREIGN KEY (`id_visitante`)
    REFERENCES `mydb`.`Visitante` (`id_Visitante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_livro_favoritado`
    FOREIGN KEY (`id_livro`)
    REFERENCES `mydb`.`Livro` (`id_Livro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_livro_stand`
    FOREIGN KEY (`id_stand`)
    REFERENCES `mydb`.`Stand` (`id_Stand`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
