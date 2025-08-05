<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

include 'db.php';

$data = $_POST;

if (!isset($data['amenity_id']) || !isset($data['name'])) {
    echo json_encode(["status" => "error", "message" => "Required fields missing"]);
    exit();
}

$amenity_id = intval($data['amenity_id']);
$name = $conn->real_escape_string($data['name']);

$sql = "UPDATE amenities SET name = '$name' WHERE amenity_id = $amenity_id";

if ($conn->query($sql) === TRUE) {
    echo json_encode(["status" => "success", "message" => "Amenity updated"]);
} else {
    echo json_encode(["status" => "error", "message" => "Update failed"]);
}
$conn->close();
?>
