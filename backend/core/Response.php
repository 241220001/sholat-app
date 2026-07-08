<?php
class Response {
    public static function success($data, $status = 200) {
        http_response_code($status);
        header("Content-Type: application/json");
        echo json_encode(["status" => "success", "data" => $data]);
        exit;
    }

    public static function error($message, $code, $status = 400) {
        http_response_code($status);
        header("Content-Type: application/json");
        echo json_encode(["status" => "error", "message" => $message, "code" => $code]);
        exit;
    }
    
}