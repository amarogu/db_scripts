USE `mydb`;

-- Drop existentes
DROP TRIGGER   IF EXISTS `trg_inscricao_apresentacao_lotacao`;
DROP TRIGGER   IF EXISTS `trg_inscricao_sessao_lotacao`;
DROP TRIGGER   IF EXISTS `trg_compra_valida_atualiza_stock`;

DROP PROCEDURE IF EXISTS `inscrever_visitante_apresentacao`;
DROP PROCEDURE IF EXISTS `cancelar_inscricao_apresentacao`;
DROP PROCEDURE IF EXISTS `atualizar_estado_vagas_apresentacao`;

DROP FUNCTION  IF EXISTS `fn_vagas_restantes_apresentacao`;


-- Gatilhos

-- RF17: bloqueia inscricao em apresentacao cheia
DELIMITER $$

CREATE TRIGGER `trg_inscricao_apresentacao_lotacao`
BEFORE INSERT ON `Inscreve_Apresentacao`
FOR EACH ROW
BEGIN
    DECLARE v_inscritos_ativos INT;
    DECLARE v_lotacao_max      INT;

    IF NEW.`estado` = 'ativa' THEN

        SELECT `lotacao_max`
          INTO v_lotacao_max
          FROM `Apresentacao`
         WHERE `id_apresentacao` = NEW.`id_apresentacao`
         FOR UPDATE;

        SELECT COUNT(*)
          INTO v_inscritos_ativos
          FROM `Inscreve_Apresentacao`
         WHERE `id_apresentacao` = NEW.`id_apresentacao`
           AND `estado` = 'ativa';

        IF v_inscritos_ativos >= v_lotacao_max THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Inscricao recusada: lotacao maxima da apresentacao atingida.';
        END IF;

    END IF;
END$$

DELIMITER ;


-- RF17: bloqueia inscricao em sessao de autografos cheia
DELIMITER $$

CREATE TRIGGER `trg_inscricao_sessao_lotacao`
BEFORE INSERT ON `Inscreve_Sessao`
FOR EACH ROW
BEGIN
    DECLARE v_inscritos_ativos INT;
    DECLARE v_lotacao_max      INT;

    IF NEW.`estado` = 'ativa' THEN

        SELECT `lotacao_max`
          INTO v_lotacao_max
          FROM `SessaoAutografos`
         WHERE `id_sessao` = NEW.`id_sessao`
         FOR UPDATE;

        SELECT COUNT(*)
          INTO v_inscritos_ativos
          FROM `Inscreve_Sessao`
         WHERE `id_sessao` = NEW.`id_sessao`
           AND `estado` = 'ativa';

        IF v_inscritos_ativos >= v_lotacao_max THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Inscricao recusada: lotacao maxima da sessao de autografos atingida.';
        END IF;

    END IF;
END$$

DELIMITER ;


-- RF25: valida stock e decrementa quantidade na compra
DELIMITER $$

CREATE TRIGGER `trg_compra_valida_atualiza_stock`
BEFORE INSERT ON `Compra`
FOR EACH ROW
BEGIN
    DECLARE v_stock_atual INT;

    SELECT `quantidade` INTO v_stock_atual
      FROM `StockStand`
     WHERE `id_stand` = NEW.`id_stand`
       AND `id_livro` = NEW.`id_livro`
     FOR UPDATE;

    IF v_stock_atual IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O livro indicado nao esta disponivel neste stand.';
    END IF;

    IF v_stock_atual < NEW.`quantidade` THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock insuficiente para a quantidade solicitada.';
    END IF;

    UPDATE `StockStand`
       SET `quantidade` = `quantidade` - NEW.`quantidade`
     WHERE `id_stand` = NEW.`id_stand`
       AND `id_livro` = NEW.`id_livro`;
END$$

DELIMITER ;


-- Procedimentos

-- Recalcula estado_vagas a partir das inscricoes ativas
DELIMITER $$

CREATE PROCEDURE `atualizar_estado_vagas_apresentacao`(
    IN p_id_apresentacao INT
)
BEGIN
    DECLARE v_lotacao   INT DEFAULT 0;
    DECLARE v_inscritos INT DEFAULT 0;

    SELECT `lotacao_max` INTO v_lotacao
      FROM `Apresentacao`
     WHERE `id_apresentacao` = p_id_apresentacao;

    SELECT COUNT(*) INTO v_inscritos
      FROM `Inscreve_Apresentacao`
     WHERE `id_apresentacao` = p_id_apresentacao
       AND `estado` = 'ativa';

    UPDATE `Apresentacao`
       SET `estado_vagas` = IF(v_inscritos >= v_lotacao, 'esgotado', 'disponivel')
     WHERE `id_apresentacao` = p_id_apresentacao;
END$$

DELIMITER ;


-- RF15/RF17: inscricao em apresentacao com validacao de lotacao
DELIMITER $$

CREATE PROCEDURE `inscrever_visitante_apresentacao`(
    IN  p_id_visitante    INT,
    IN  p_id_apresentacao INT,
    OUT p_id_inscricao    INT
)
BEGIN
    DECLARE v_inscritos_ativos INT DEFAULT 0;
    DECLARE v_lotacao_max      INT DEFAULT 0;
    DECLARE v_existe_visit     INT DEFAULT 0;
    DECLARE v_existe_apres     INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_existe_visit
      FROM `Visitante`
     WHERE `id_visitante` = p_id_visitante;

    IF v_existe_visit = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Visitante nao encontrado.';
    END IF;

    SELECT COUNT(*), MAX(`lotacao_max`)
      INTO v_existe_apres, v_lotacao_max
      FROM `Apresentacao`
     WHERE `id_apresentacao` = p_id_apresentacao
     FOR UPDATE;

    IF v_existe_apres = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Apresentacao nao encontrada.';
    END IF;

    SELECT COUNT(*) INTO v_inscritos_ativos
      FROM `Inscreve_Apresentacao`
     WHERE `id_apresentacao` = p_id_apresentacao
       AND `estado` = 'ativa';

    IF v_inscritos_ativos >= v_lotacao_max THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lotacao maxima atingida - inscricao recusada.';
    END IF;

    INSERT INTO `Inscreve_Apresentacao`
           (`data_inscricao`, `estado`,
            `id_visitante`, `id_apresentacao`)
    VALUES (CURDATE(), 'ativa', p_id_visitante, p_id_apresentacao);

    SET p_id_inscricao = LAST_INSERT_ID();

    IF (v_inscritos_ativos + 1) >= v_lotacao_max THEN
        UPDATE `Apresentacao`
           SET `estado_vagas` = 'esgotado'
         WHERE `id_apresentacao` = p_id_apresentacao;
    END IF;

    COMMIT;
END$$

DELIMITER ;


-- RF19: cancelamento logico (preserva historico) e liberta vaga
DELIMITER $$

CREATE PROCEDURE `cancelar_inscricao_apresentacao`(
    IN p_id_inscricao INT
)
BEGIN
    DECLARE v_estado_atual    VARCHAR(20);
    DECLARE v_id_apresentacao INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT `estado`, `id_apresentacao`
      INTO v_estado_atual, v_id_apresentacao
      FROM `Inscreve_Apresentacao`
     WHERE `id_inscreve_apresentacao` = p_id_inscricao
     FOR UPDATE;

    IF v_estado_atual IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Inscricao nao encontrada.';
    END IF;

    IF v_estado_atual = 'cancelada' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Inscricao ja se encontra cancelada.';
    END IF;

    UPDATE `Inscreve_Apresentacao`
       SET `estado` = 'cancelada'
     WHERE `id_inscreve_apresentacao` = p_id_inscricao;

    CALL `atualizar_estado_vagas_apresentacao`(v_id_apresentacao);

    COMMIT;
END$$

DELIMITER ;


-- Funcoes

-- Vagas restantes (lotacao - inscritos ativos)
DELIMITER $$

CREATE FUNCTION `fn_vagas_restantes_apresentacao`(
    p_id_apresentacao INT
) RETURNS INT
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_lotacao   INT DEFAULT 0;
    DECLARE v_inscritos INT DEFAULT 0;

    SELECT `lotacao_max` INTO v_lotacao
      FROM `Apresentacao`
     WHERE `id_apresentacao` = p_id_apresentacao;

    SELECT COUNT(*) INTO v_inscritos
      FROM `Inscreve_Apresentacao`
     WHERE `id_apresentacao` = p_id_apresentacao
       AND `estado` = 'ativa';

    RETURN GREATEST(v_lotacao - v_inscritos, 0);
END$$

DELIMITER ;
