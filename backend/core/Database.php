<?php
class Database {
    private static $instance = null;
    private $conn;

    private function __construct() {
        $host = "localhost";
        $user = "root";
        $pass = "";        // XAMPP default kosong

        try {
            $dsn = "mysql:host={$host};dbname={$dbname};charset=utf8mb4";
            $this->conn = new PDO($dsn, $user, $pass);
            $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch (PDOException $e) {
            http_response_code(500);
            header("Content-Type: application/json");
            echo json_encode([
                "status" => "error",
                "message" => "Koneksi database gagal",
                "code" => "DB_CONNECTION_FAILED"
            ]);
            exit;
        }
    }

    public static function getConnection() {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance->conn;
    }
    
}