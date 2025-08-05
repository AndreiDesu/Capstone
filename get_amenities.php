<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// ✅ Include centralized DB connection
require_once 'db.php'; // Adjust path if db.php is in another folder

$sql = "SELECT * FROM amenities";
$result = $conn->query($sql);

$amenities = [];

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $amenities[] = $row;
    }
    echo json_encode(["status" => "success", "data" => $amenities]);
} else {
    echo json_encode(["status" => "success", "data" => []]);
}

$conn->close();
?>
