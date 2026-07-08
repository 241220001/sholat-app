<?php
require_once __DIR__ . '/../core/Database.php';
require_once __DIR__ . '/../core/Response.php';

try {
    $db = Database::getConnection();
    Response::success(["message" => "Koneksi database berhasil!"]);
} catch (Exception $e) {
    Response::error("Koneksi database gagal", "DB_ERROR", 500);
}