<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

$conn = new mysqli("localhost", "root", "", "capstone");

if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "Connection failed"]);
    exit();
}

$sql = "SELECT id, title, image_url FROM promos";
$result = $conn->query($sql);

$promos = [];
while ($row = $result->fetch_assoc()) {
    $promos[] = $row;
}

echo json_encode(["status" => "success", "data" => $promos]);
?>
