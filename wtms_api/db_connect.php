<?php
$host = "localhost";
$user = "root";
$password = "";
$database = "wtms_db";

$conn = mysqli_connect($host, $user, $password, $database);

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}
?>
