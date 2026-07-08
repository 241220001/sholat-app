<?php
   require_once __DIR__ . '/core/Database.php';

   try {
       $db = Database::getConnection();
       echo "✅ Koneksi berhasil!";
   } catch (Exception $e) {
       echo "❌ Gagal: " . $e->getMessage();
   }