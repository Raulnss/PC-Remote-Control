CREATE DATABASE IF NOT EXISTS meu_sistema;
USE meu_sistema;
CREATE TABLE IF NOT EXISTS comandos (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `codigo` VARCHAR(20) NOT NULL,
    `acao` VARCHAR(255) NOT NULL,
    `enviado` TINYINT(1) DEFAULT 0,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_codigo_enviado ON comandos(codigo, enviado);