<?php
include "db_connect.php";

$data = json_decode(file_get_contents("php://input"), true);

$full_name = $data['full_name'];
$email = $data['email'];
$password = sha1($data['password']);
$phone = $data['phone'];
$address = $data['address'];

$sql = "INSERT INTO workers (full_name, email, password, phone, address)
        VALUES ('$full_name', '$email', '$password', '$phone', '$address')";

if (mysqli_query($conn, $sql)) {
    echo json_encode(["success" => true]);
} else {
    echo json_encode(["success" => false, "error" => mysqli_error($conn)]);
}
?>