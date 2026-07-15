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
            $kategori = $_GET['kategori'] ?? null;
            
            if ($kategori && in_array($kategori, ['dewasa', 'anak'])) {
                $idKategori = Gerakan::resolveKategoriId($kategori);
                if (!$idKategori) {
                    Response::error("Kategori tidak ditemukan", "KATEGORI_NOT_FOUND", 404);
                }
                $gerakan = Gerakan::findByUrutanAndKategori($id, $idKategori);
            } else {
                $gerakan = Gerakan::findById($id);
            }
            
            if (!$gerakan) {
                Response::error("Gerakan tidak ditemukan", "GERAKAN_NOT_FOUND", 404);
            }
            
            Response::success($gerakan);
        } catch (Exception $e) {
            Response::error("Terjadi kesalahan server", "SERVER_ERROR", 500);
        }
    }

    public static function next() {
        $idKategori = $_GET['id_kategori'] ?? null;
        $urutan = $_GET['urutan'] ?? null;

        if (!$idKategori || !is_numeric($idKategori) || $urutan === null || !is_numeric($urutan)) {
            Response::error("Parameter id_kategori dan urutan wajib diisi dan berupa angka", "INVALID_PARAMS", 400);
        }

        try {
            $gerakan = Gerakan::findNext((int)$idKategori, (int)$urutan);
            if (!$gerakan) {
                Response::error("Tidak ada gerakan berikutnya", "NO_NEXT_GERAKAN", 404);
            }
            Response::success($gerakan);
        } catch (Exception $e) {
            Response::error("Terjadi kesalahan server", "SERVER_ERROR", 500);
        }
    }

    public static function prev() {
        $idKategori = $_GET['id_kategori'] ?? null;
        $urutan = $_GET['urutan'] ?? null;

        if (!$idKategori || !is_numeric($idKategori) || $urutan === null || !is_numeric($urutan)) {
            Response::error("Parameter id_kategori dan urutan wajib diisi dan berupa angka", "INVALID_PARAMS", 400);
        }

        try {
            $gerakan = Gerakan::findPrev((int)$idKategori, (int)$urutan);
            if (!$gerakan) {
                Response::error("Tidak ada gerakan sebelumnya", "NO_PREV_GERAKAN", 404);
            }
            Response::success($gerakan);
        } catch (Exception $e) {
            Response::error("Terjadi kesalahan server", "SERVER_ERROR", 500);
        }
    }

    public static function total() {
        $kategori = $_GET['kategori'] ?? null;

        if (!$kategori || !in_array($kategori, ['dewasa', 'anak'])) {
            Response::error("Parameter kategori wajib diisi: dewasa atau anak", "INVALID_KATEGORI", 400);
        }

        try {
            $idKategori = Gerakan::resolveKategoriId($kategori);
            if (!$idKategori) {
                Response::error("Kategori tidak ditemukan", "KATEGORI_NOT_FOUND", 404);
            }
            $total = Gerakan::countByKategori($idKategori);
            Response::success(["total_gerakan" => $total]);
        } catch (Exception $e) {
            Response::error("Terjadi kesalahan server", "SERVER_ERROR", 500);
        }
    }

    public static function autoplay() {
        $kategori = $_GET['kategori'] ?? null;

        if (!$kategori || !in_array($kategori, ['dewasa', 'anak'])) {
            Response::error("Parameter kategori wajib diisi: dewasa atau anak", "INVALID_KATEGORI", 400);
        }

        try {
            $idKategori = Gerakan::resolveKategoriId($kategori);
            if (!$idKategori) {
                Response::error("Kategori tidak ditemukan", "KATEGORI_NOT_FOUND", 404);
            }
            $data = Gerakan::findAutoplay($idKategori);
            Response::success($data);
        } catch (Exception $e) {
            Response::error("Terjadi kesalahan server", "SERVER_ERROR", 500);
        }
    }
}