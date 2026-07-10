<?php
require_once __DIR__ . '/../models/Bacaan.php';
require_once __DIR__ . '/../core/Response.php';

class BacaanController {
    public static function index() {
        $idGerakan = $_GET['id_gerakan'] ?? null;
        
        if (!$idGerakan || !is_numeric($idGerakan)) {
            Response::error("Parameter id_gerakan wajib diisi dan harus berupa angka", "INVALID_ID_GERAKAN", 400);
        }
        
        $idGerakan = (int)$idGerakan;
        
        try {
            $bacaan = Bacaan::findByGerakan($idGerakan);
            
            Response::success($bacaan);
        } catch (Exception $e) {
            Response::error("Terjadi kesalahan server", "SERVER_ERROR", 500);
        }
    }
}