<?php
header("Access-Control-Allow-Origin: *"); // ou coloque "http://localhost:port" se quiser restringir
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Accept, Authorization");

// Responde requisições OPTIONS automaticamente (pré-flight)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit();
}
include 'conecta.php';
$conn = getConnection();
$dados = array("cod" => $_POST['cod'], "com" => $_POST['com']);
$dados = array_map("trim", $dados);
$sucess = 0;
try{
    if(isset($dados['cod']) && isset($dados['com']) && !empty($dados['cod']) && !empty($dados['com'])){
        $veri = $conn->prepare('INSERT INTO comandos (codigo, acao) VALUES (:codigo, :acao)');
        $veri->execute(array(
            ":codigo" => $dados['cod'],
            ":acao" => $dados['com']
        ));  
       $msg = "ok";
    } else {
        $msg = "Nenhum valor foi encontrado.";
    }
} catch(\Throwable $th) {
    $msg = "Error: " . $th->getMessage(); 
}
echo json_encode([
    "data" => [
        $msg,
        $smtd,
        $sucess
    ]
]);