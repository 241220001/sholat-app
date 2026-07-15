<?php
require_once __DIR__ . '/../models/Kelompok.php';
require_once __DIR__ . '/../core/Response.php';

class KelompokController {
    public static function index() {
        try {
            $kelompok = Kelompok::getInfo();
            
            if (!$kelompok) {
                Response::error("Data kelompok belum tersedia", "KELOMPOK_NOT_CONFIGURED", 404);
            }
            
            Response::success($kelompok);
        } catch (Exception $e) {
            Response::error("Terjadi kesalahan server", "SERVER_ERROR", 500);
        }
    }
}
