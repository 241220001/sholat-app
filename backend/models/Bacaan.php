<?php
require_once __DIR__ . '/../core/Database.php';

class Bacaan {
    public static function findByGerakan($idGerakan) {
        $db = Database::getConnection();
        $stmt = $db->prepare('SELECT id, urutan, teks_arab, teks_latin, terjemahan, audio_url, sumber 
                              FROM bacaan 
                              WHERE id_gerakan = :id_gerakan 
                              ORDER BY urutan ASC');
        $stmt->execute(['id_gerakan' => $idGerakan]);
        return $stmt->fetchAll();
    }
}
