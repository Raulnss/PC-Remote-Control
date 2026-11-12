<?php
function getConnection() {
    try {
        $conn = new PDO('mysql:host=;port=;dbname=', '', '');
        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $conn->exec("SET time_zone = '-03:00';"); // ou 'America/Sao_Paulo' se suportado pelo servidor
        return $conn;
    } catch (PDOException $e) {
        die('Erro na conexão: ' . $e->getMessage());
    }
}