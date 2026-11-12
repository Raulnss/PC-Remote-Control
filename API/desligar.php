<?php
header('Content-Type: text/event-stream');
header('Cache-Control: no-cache');
header('Connection: keep-alive');
include 'conecta.php';
$conn = getConnection();
while(true){
    $stmt = $pdo->prepare("SELECT * FROM comandos WHERE codigo = ? AND enviado = 0 ORDER BY timestamp ASC");
    $stmt->execute([$codigo]);
    $comandos = $stmt->fetchAll(PDO::FETCH_ASSOC);
    foreach($comandos as $cmd){
        echo "data: " . json_encode($cmd['acao']) . "\n\n";
        ob_flush();
        flush();
        // Marca comando como enviado
        $update = $pdo->prepare("UPDATE comandos SET enviado = 1 WHERE id = ?");
        $update->execute([$cmd['id']]);
    }
    sleep(1);
}