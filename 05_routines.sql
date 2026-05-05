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

-- RF17: bloqueia inscrição em apresentação cheia
DELIMITER $$

CREATE TRIGGER `trg_inscricao_apresentacao_lotacao`
BEFORE INSERT ON `Inscreve_Apresentação`
FOR EACH ROW
BEGIN
    DECLARE v_inscritos_ativos INT;
    DECLARE v_lotacao_max      INT;

    IF NEW.`estado` = 'ativa' THEN

        SELECT `lotação_max`
          INTO v_lotacao_max
          FROM `Apresentação`
         WHERE `id_Apresentação` = NEW.`id_increve_apresentaçao`
         FOR UPDATE;

        SELECT COUNT(*)
          INTO v_inscritos_ativos
          FROM `Inscreve_Apresentação`
         WHERE `id_increve_apresentaçao` = NEW.`id_increve_apresentaçao`
           AND `estado` = 'ativa';

        IF v_inscritos_ativos >= v_lotacao_max THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Inscrição recusada: lotação máxima da apresentação atingida.';
        END IF;

    END IF;
END$$

DELIMITER ;


-- RF17: bloqueia inscrição em sessão de autógrafos cheia
DELIMITER $$

CREATE TRIGGER `trg_inscricao_sessao_lotacao`
BEFORE INSERT ON `Inscreve_Sessao`
FOR EACH ROW
BEGIN
    DECLARE v_inscritos_ativos INT;
    DECLARE v_lotacao_max      INT;

    IF NEW.`estado` = 'ativa' THEN

        SELECT `lotaçao_max`
          INTO v_lotacao_max
          FROM `SessaoAutografos`
         WHERE `id_SessaoAutografos` = NEW.`id_sessao_inscreve`
         FOR UPDATE;

        SELECT COUNT(*)
          INTO v_inscritos_ativos
          FROM `Inscreve_Sessao`
         WHERE `id_sessao_inscreve` = NEW.`id_sessao_inscreve`
           AND `estado` = 'ativa';

        IF v_inscritos_ativos >= v_lotacao_max THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Inscrição recusada: lotação máxima da sessão de autógrafos atingida.';
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
     WHERE `id_Stand` = NEW.`id_stand`
       AND `id_livro` = NEW.`id_livro`
     FOR UPDATE;

    IF v_stock_atual IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O livro indicado não está disponível neste stand.';
    END IF;

    IF v_stock_atual < NEW.`quantidade` THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock insuficiente para a quantidade solicitada.';
    END IF;

    UPDATE `StockStand`
       SET `quantidade` = `quantidade` - NEW.`quantidade`
     WHERE `id_Stand` = NEW.`id_stand`
       AND `id_livro` = NEW.`id_livro`;
END$$

DELIMITER ;


-- Procedimentos

-- Recalcula estado_vagas a partir das inscrições ativas
DELIMITER $$

CREATE PROCEDURE `atualizar_estado_vagas_apresentacao`(
    IN p_id_apresentacao INT
)
BEGIN
    DECLARE v_lotacao   INT DEFAULT 0;
    DECLARE v_inscritos INT DEFAULT 0;

    SELECT `lotação_max` INTO v_lotacao
      FROM `Apresentação`
     WHERE `id_Apresentação` = p_id_apresentacao;

    SELECT COUNT(*) INTO v_inscritos
      FROM `Inscreve_Apresentação`
     WHERE `id_increve_apresentaçao` = p_id_apresentacao
       AND `estado` = 'ativa';

    UPDATE `Apresentação`
       SET `estado_vagas` = IF(v_inscritos >= v_lotacao, ' esgotado', 'disponível')
     WHERE `id_Apresentação` = p_id_apresentacao;
END$$

DELIMITER ;


-- RF15/RF17: inscrição em apresentação com validação de lotação
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
     WHERE `id_Visitante` = p_id_visitante;

    IF v_existe_visit = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Visitante não encontrado.';
    END IF;

    SELECT COUNT(*), MAX(`lotação_max`)
      INTO v_existe_apres, v_lotacao_max
      FROM `Apresentação`
     WHERE `id_Apresentação` = p_id_apresentacao
     FOR UPDATE;

    IF v_existe_apres = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Apresentação não encontrada.';
    END IF;

    SELECT COUNT(*) INTO v_inscritos_ativos
      FROM `Inscreve_Apresentação`
     WHERE `id_increve_apresentaçao` = p_id_apresentacao
       AND `estado` = 'ativa';

    IF v_inscritos_ativos >= v_lotacao_max THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lotação máxima atingida — inscrição recusada.';
    END IF;

    INSERT INTO `Inscreve_Apresentação`
           (`data_incriçao`, `estado`,
            `id_visitante_increve`, `id_increve_apresentaçao`)
    VALUES (CURDATE(), 'ativa', p_id_visitante, p_id_apresentacao);

    SET p_id_inscricao = LAST_INSERT_ID();

    IF (v_inscritos_ativos + 1) >= v_lotacao_max THEN
        UPDATE `Apresentação`
           SET `estado_vagas` = ' esgotado'
         WHERE `id_Apresentação` = p_id_apresentacao;
    END IF;

    COMMIT;
END$$

DELIMITER ;


-- RF19: cancelamento lógico (preserva histórico) e liberta vaga
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

    SELECT `estado`, `id_increve_apresentaçao`
      INTO v_estado_atual, v_id_apresentacao
      FROM `Inscreve_Apresentação`
     WHERE `id_Inscreve_Apresentação` = p_id_inscricao
     FOR UPDATE;

    IF v_estado_atual IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Inscrição não encontrada.';
    END IF;

    IF v_estado_atual = 'cancelada' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Inscrição já se encontra cancelada.';
    END IF;

    UPDATE `Inscreve_Apresentação`
       SET `estado` = 'cancelada'
     WHERE `id_Inscreve_Apresentação` = p_id_inscricao;

    CALL `atualizar_estado_vagas_apresentacao`(v_id_apresentacao);

    COMMIT;
END$$

DELIMITER ;


-- Funções

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

    SELECT `lotação_max` INTO v_lotacao
      FROM `Apresentação`
     WHERE `id_Apresentação` = p_id_apresentacao;

    SELECT COUNT(*) INTO v_inscritos
      FROM `Inscreve_Apresentação`
     WHERE `id_increve_apresentaçao` = p_id_apresentacao
       AND `estado` = 'ativa';

    RETURN GREATEST(v_lotacao - v_inscritos, 0);
END$$

DELIMITER ;
