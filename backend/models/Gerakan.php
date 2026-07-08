<?php
require_once __DIR__ . '/../core/Database.php';

class Gerakan {
    public static function findByKategori($kategoriNama) {
        $db = Database::getConnection();
        
        $stmtKategori = $db->prepare('SELECT id FROM kategori WHERE nama = :nama LIMIT 1');
        $stmtKategori->execute(['nama' => $kategoriNama]);
        $kategori = $stmtKategori->fetch();
        
        if (!$kategori) {
            return null;
        }
        
        $stmt = $db->prepare('SELECT id, nama, urutan, deskripsi, gambar_url, video_url 
                              FROM gerakan 
                              WHERE id_kategori = :id_kategori 
                              ORDER BY urutan ASC');
        $stmt->execute(['id_kategori' => $kategori['id']]);
        return $stmt->fetchAll();
    }
    
    public static function findById($id) {
        $db = Database::getConnection();
        $stmt = $db->prepare('SELECT id, id_kategori, nama, urutan, deskripsi, gambar_url, video_url 
                              FROM gerakan 
                              WHERE id = :id');
        $stmt->execute(['id' => $id]);
        $row = $stmt->fetch();
        return $row ?: null;
    }
}
