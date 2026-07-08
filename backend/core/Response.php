<?php
class Response {
    public static function success($data, $status = 200) {
        http_response_code($status);
        header("Content-Type: application/json; charset=utf-8");
        echo json_encode(["status" => "success", "data" => $data], JSON_UNESCAPED_UNICODE);
        exit;
    }

    public static function error($message, $code, $status = 400) {
        http_response_code($status);
        header("Content-Type: application/json; charset=utf-8");
        echo json_encode(["status" => "error", "message" => $message, "code" => $code], JSON_UNESCAPED_UNICODE);
        exit;
    }
    
}