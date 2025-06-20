<?php
include "db_connect.php";

header("Content-Type: application/json");

// Read input
$data = json_decode(file_get_contents("php://input"), true);

if (!$data || !isset($data['worker_id'])) {
    echo json_encode(["success" => false, "message" => "Missing worker_id"]);
    exit;
}

$worker_id = intval($data['worker_id']);

$sql = "SELECT id, full_name, email, phone, address FROM workers WHERE id = $worker_id";
$result = mysqli_query($conn, $sql);

if ($row = mysqli_fetch_assoc($result)) {
    echo json_encode(["success" => true, "worker" => $row]);
} else {
    echo json_encode(["success" => false, "message" => "Worker not found"]);
}
?>