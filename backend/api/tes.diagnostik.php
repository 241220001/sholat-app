<?php
header("Content-Type: application/json; charset=utf-8");

echo json_encode([
    "ini_file_bacaan_php" => __FILE__,
    "waktu_sekarang" => date('Y-m-d H:i:s'),
    "isi_bacaan_controller" => file_get_contents(__DIR__ . '/../controllers/BacaanController.php'),
], JSON_PRETTY_PRINT);