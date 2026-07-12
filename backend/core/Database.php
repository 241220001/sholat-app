<?php
class Database {
    private static $instance = null;
    private $conn;

    private function __construct() {
        $envPath = __DIR__ . '/../../.env';
        if (!file_exists($envPath)) {
            http_response_code(500);
            header("Content-Type: application/json");
            echo json_encode([
                "status" => "error",
                "message" => "File .env tidak ditemukan",
                "code" => "ENV_NOT_FOUND"
            ]);
            exit;
        }

        $env = parse_ini_file($envPath);
        $host = $env['DB_HOST'] ?? 'localhost';
        $dbname = $env['DB_NAME'] ?? '';
        $user = $env['DB_USER'] ?? 'root';
        $pass = $env['DB_PASS'] ?? '';

        try {
            $dsn = "mysql:host={$host};dbname={$dbname};charset=utf8mb4";
            $this->conn = new PDO($dsn, $user, $pass);
            $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            $this->conn->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC); // tambah ini
            $this->conn->setAttribute(PDO::ATTR_EMULATE_PREPARES, false); // tambah ini
        } catch (PDOException $e) {
            die("PDO Error: " . $e->getMessage());
        }
    }

    public static function getConnection() {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance->conn;
    }
    
}