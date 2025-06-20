<?php
include "db_connect.php";

header("Content-Type: application/json");

// Read input
$data = json_decode(file_get_contents("php://input"), true);

if (
    !$data ||
    !isset($data['worker_id']) ||
    !isset($data['full_name']) ||
    !isset($data['email']) ||
    !isset($data['phone']) ||
    !isset($data['address'])
) {
    echo json_encode(["success" => false, "message" => "Missing fields"]);
    exit;
}

$worker_id = intval($data['worker_id']);
$full_name = mysqli_real_escape_string($conn, $data['full_name']);
$email     = mysqli_real_escape_string($conn, $data['email']);
$phone     = mysqli_real_escape_string($conn, $data['phone']);
$address   = mysqli_real_escape_string($conn, $data['address']);

$sql = "UPDATE workers SET 
            full_name = '$full_name',
            email = '$email',
            phone = '$phone',
            address = '$address'
        WHERE id = $worker_id";

if (mysqli_query($conn, $sql)) {
    echo json_encode(["success" => true, "message" => "Profile updated successfully"]);
} else {
    echo json_encode(["success" => false, "message" => "Update failed"]);
}
?>