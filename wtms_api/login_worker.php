<?php
include "db_connect.php";

$data = json_decode(file_get_contents("php://input"), true);

$email = $data['email'];
$password = sha1($data['password']);

$sql = "SELECT * FROM workers WHERE email = '$email' AND password = '$password'";
$result = mysqli_query($conn, $sql);
$user = mysqli_fetch_assoc($result);

if ($user) {
    echo json_encode(["success" => true, "worker" => $user]);
} else {
    echo json_encode(["success" => false, "message" => "Invalid credentials"]);
}
?>