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

if (isset($_GET['next'])) {
    GerakanController::next();
} elseif (isset($_GET['prev'])) {
    GerakanController::prev();
} elseif (isset($_GET['total'])) {
    GerakanController::total();
} elseif (isset($_GET['autoplay'])) {
    GerakanController::autoplay();
} elseif (isset($_GET['id'])) {
    GerakanController::show();
} else {
    GerakanController::index();
}