-- CRIAÇAO DO DATABASE ATRAVÉS DO SQLITE (ESTÁ TUDO AUTOMATIZADO DENTRO DA APLICAÇÃO)
-- Basta rodar o executável que a aplicação que irá criar o database automaticamente

-- QUERYS PARA CRIAÇÃO DAS TABELAS E TRIGGERS
CREATE TABLE IF NOT EXISTS Cadastro (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        campo_texto TEXT NOT NULL CHECK (trim(campo_texto) <> ''),
        campo_numerico INTEGER NOT NULL UNIQUE CHECK (campo_numerico > 0)
        ) 

CREATE TABLE IF NOT EXISTS Log_operacoes (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       operacao TEXT NOT NULL,
       data_hora TEXT DEFAUL CURRENT_TIMESTAMP
      )

CREATE TRIGGER IF NOT EXISTS log_insert 
      AFTER INSERT ON cadastro
      BEGIN
        INSERT INTO Log_operacoes (operacao, data_hora)
        VALUES ('INSERT', CURRENT_TIMESTAMP);
      END;

CREATE TRIGGER IF NOT EXISTS log_update 
      AFTER UPDATE ON cadastro
      BEGIN
        INSERT INTO Log_operacoes (operacao, data_hora)
        VALUES ('UPDATE', CURRENT_TIMESTAMP);
      END;

CREATE TRIGGER IF NOT EXISTS log_delete 
      AFTER DELETE ON cadastro
      BEGIN
        INSERT INTO Log_operacoes (operacao, data_hora)
        VALUES ('DELETE', CURRENT_TIMESTAMP);
      END;