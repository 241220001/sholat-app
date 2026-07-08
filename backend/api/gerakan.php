<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    header("Content-Type: application/json; charset=utf-8");
    echo json_encode(["status" => "error", "message" => "Method tidak diizinkan", "code" => "METHOD_NOT_ALLOWED"], JSON_UNESCAPED_UNICODE);
    exit;
}

require_once __DIR__ . '/../controllers/GerakanController.php';

if (isset($_GET['id'])) {
    GerakanController::show();
} else {
    GerakanController::index();
}
