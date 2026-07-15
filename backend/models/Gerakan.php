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

    public static function findByUrutanAndKategori($urutan, $idKategori) {
        $db = Database::getConnection();
        $stmt = $db->prepare('SELECT id, id_kategori, nama, urutan, deskripsi, gambar_url, video_url
                              FROM gerakan
                              WHERE urutan = :urutan AND id_kategori = :id_kategori
                              LIMIT 1');
        $stmt->execute(['urutan' => $urutan, 'id_kategori' => $idKategori]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public static function resolveKategoriId($kategoriNama) {
        $db = Database::getConnection();
        $stmt = $db->prepare('SELECT id FROM kategori WHERE nama = :nama LIMIT 1');
        $stmt->execute(['nama' => $kategoriNama]);
        $row = $stmt->fetch();
        return $row ? $row['id'] : null;
    }

    public static function findNext($idKategori, $urutanSekarang) {
        $db = Database::getConnection();
        $stmt = $db->prepare('SELECT id, nama, urutan 
                              FROM gerakan 
                              WHERE id_kategori = :id_kategori AND urutan > :urutan 
                              ORDER BY urutan ASC LIMIT 1');
        $stmt->execute(['id_kategori' => $idKategori, 'urutan' => $urutanSekarang]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public static function findPrev($idKategori, $urutanSekarang) {
        $db = Database::getConnection();
        $stmt = $db->prepare('SELECT id, nama, urutan 
                              FROM gerakan 
                              WHERE id_kategori = :id_kategori AND urutan < :urutan 
                              ORDER BY urutan DESC LIMIT 1');
        $stmt->execute(['id_kategori' => $idKategori, 'urutan' => $urutanSekarang]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public static function countByKategori($idKategori) {
        $db = Database::getConnection();
        $stmt = $db->prepare('SELECT COUNT(*) AS total FROM gerakan WHERE id_kategori = :id_kategori');
        $stmt->execute(['id_kategori' => $idKategori]);
        $row = $stmt->fetch();
        return (int) $row['total'];
    }

    public static function findAutoplay($idKategori) {
        $db = Database::getConnection();
        $stmt = $db->prepare('
            SELECT
              g.id AS gerakan_id, g.nama AS gerakan_nama, g.urutan AS gerakan_urutan,
              g.gambar_url, g.video_url,
              b.id AS bacaan_id, b.urutan AS bacaan_urutan,
              b.teks_arab, b.teks_latin, b.terjemahan, b.audio_url, b.sumber
            FROM gerakan g
            LEFT JOIN bacaan b ON b.id_gerakan = g.id
            WHERE g.id_kategori = :id_kategori
            ORDER BY g.urutan ASC, b.urutan ASC
        ');
        $stmt->execute(['id_kategori' => $idKategori]);
        $rows = $stmt->fetchAll();

        $result = [];
        foreach ($rows as $row) {
            $gid = $row['gerakan_id'];
            if (!isset($result[$gid])) {
                $result[$gid] = [
                    'id' => $row['gerakan_id'],
                    'nama' => $row['gerakan_nama'],
                    'urutan' => $row['gerakan_urutan'],
                    'gambar_url' => $row['gambar_url'],
                    'video_url' => $row['video_url'],
                    'bacaan' => []
                ];
            }
            if ($row['bacaan_id'] !== null) {
                $result[$gid]['bacaan'][] = [
                    'id' => $row['bacaan_id'],
                    'urutan' => $row['bacaan_urutan'],
                    'teks_arab' => $row['teks_arab'],
                    'teks_latin' => $row['teks_latin'],
                    'terjemahan' => $row['terjemahan'],
                    'audio_url' => $row['audio_url'],
                    'sumber' => $row['sumber'],
                ];
            }
        }
        return array_values($result);
    }
}