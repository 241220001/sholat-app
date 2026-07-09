<?php
require_once __DIR__ . '/../core/Database.php';

class Kelompok {
    public static function getInfo() {
        $db = Database::getConnection();
        $stmt = $db->prepare('SELECT nama_kelompok, prodi, mata_kuliah, dosen FROM kelompok LIMIT 1');
        $stmt->execute();
        $row = $stmt->fetch();
        return $row ?: null;
    }
}
