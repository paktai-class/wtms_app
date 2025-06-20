<?php
include "db_connect.php";

header("Content-Type: application/json");

// Read input
$data = json_decode(file_get_contents("php://input"), true);

if (!$data || !isset($data['submission_id']) || !isset($data['report'])) {
    echo json_encode(["success" => false, "message" => "Missing fields"]);
    exit;
}

$submission_id = intval($data['submission_id']);
$report = mysqli_real_escape_string($conn, $data['report']);

$sql = "UPDATE tbl_submissions SET report = '$report' WHERE submission_id = $submission_id";

if (mysqli_query($conn, $sql)) {
    echo json_encode(["success" => true, "message" => "Submission updated successfully"]);
} else {
    echo json_encode(["success" => false, "message" => "Update failed"]);
}
?>