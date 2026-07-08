<?php
require_once __DIR__ . '/../models/Gerakan.php';
require_once __DIR__ . '/../core/Response.php';

class GerakanController {
    public static function index() {
        $kategori = $_GET['kategori'] ?? null;
        
        if (!$kategori) {
            Response::error("Parameter kategori wajib diisi: dewasa atau anak", "INVALID_KATEGORI", 400);
        }
        
        if (!in_array($kategori, ['dewasa', 'anak'])) {
            Response::error("Parameter kategori wajib diisi: dewasa atau anak", "INVALID_KATEGORI", 400);
        }
        
        try {
            $gerakan = Gerakan::findByKategori($kategori);
            
            if ($gerakan === null) {
                Response::error("Kategori tidak ditemukan", "KATEGORI_NOT_FOUND", 404);
            }
            
            Response::success($gerakan);
        } catch (Exception $e) {
            Response::error("Terjadi kesalahan server", "SERVER_ERROR", 500);
        }
    }
    
    public static function show() {
        $id = $_GET['id'] ?? null;
        
        if (!$id || !is_numeric($id)) {
            Response::error("ID gerakan tidak valid", "INVALID_ID", 400);
        }
        
        $id = (int)$id;
        
        try {
            $gerakan = Gerakan::findById($id);
            
            if (!$gerakan) {
                Response::error("Gerakan tidak ditemukan", "GERAKAN_NOT_FOUND", 404);
            }
            
            Response::success($gerakan);
        } catch (Exception $e) {
            Response::error("Terjadi kesalahan server", "SERVER_ERROR", 500);
        }
    }
}
