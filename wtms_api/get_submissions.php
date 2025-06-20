<?php
include "db_connect.php";

header("Content-Type: application/json");

// Read JSON input
$data = json_decode(file_get_contents("php://input"), true);

// Validate input
if (!$data || !isset($data['worker_id'])) {
    echo json_encode(["success" => false, "message" => "Missing worker_id"]);
    exit;
}

$worker_id = intval($data['worker_id']);

$sql = "SELECT s.submission_id, s.work_id, w.title, s.report, s.timestamp
        FROM tbl_submissions s
        JOIN tbl_works w ON s.work_id = w.work_id
        WHERE s.worker_id = $worker_id
        ORDER BY s.timestamp DESC";

$result = mysqli_query($conn, $sql);

$submissions = [];

while ($row = mysqli_fetch_assoc($result)) {
    $submissions[] = $row;
}

echo json_encode($submissions);
?>
