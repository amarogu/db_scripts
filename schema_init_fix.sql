ALTER TABLE Inscreve_Apresentação
    DROP INDEX id_visitante_UNIQUE,
    DROP INDEX id_apresentaçao_UNIQUE,
    ADD UNIQUE INDEX uk_inscricao_apresentacao
        (id_visitante_increve, id_increve_apresentaçao);

ALTER TABLE Inscreve_Sessao
    DROP INDEX id_visitante_UNIQUE,
    DROP INDEX id_sessao_UNIQUE,
    ADD UNIQUE INDEX uk_inscricao_sessao
        (id_increve_sessao_visitante, id_sessao_inscreve);

ALTER TABLE Inscreve_Feira
    DROP INDEX id_visitante_UNIQUE,
    DROP INDEX id_feira_UNIQUE,
    ADD UNIQUE INDEX uk_inscricao_feira
        (id_increve_feira_visitante, id_increve_feira);