<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

include "db_connect.php";


$rawData = file_get_contents("php://input");
$data = json_decode($rawData, true);


if (!$data || !isset($data['worker_id'])) {
    echo json_encode([]);
    exit;
}

$worker_id = intval($data['worker_id']);

$sql = "SELECT * FROM tbl_works WHERE worker_id = $worker_id";
$result = mysqli_query($conn, $sql);

$tasks = [];

if ($result && mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_assoc($result)) {
        $tasks[] = $row;
    }
}

echo json_encode($tasks);
?>
