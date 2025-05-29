<?php
include "db_connect.php";

$data = json_decode(file_get_contents("php://input"), true);

$worker_id = $data['worker_id'];
$work_id = $data['work_id'];
$report = $data['report'];

$sql = "INSERT INTO tbl_submissions (work_id, worker_id, report) VALUES ('$work_id', '$worker_id', '$report')";

if (mysqli_query($conn, $sql)) {
    echo json_encode(["success" => true]);
} else {
    echo json_encode(["success" => false, "error" => mysqli_error($conn)]);
}
?>