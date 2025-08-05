<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

// ✅ Include centralized DB connection
require_once 'db.php'; // Adjust path if db.php is in another folder

$sql = "SELECT * FROM packages";
$result = $conn->query($sql);

$packages = [];

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $packages[] = $row;
    }
    echo json_encode(["status" => "success", "data" => $packages]);
} else {
    echo json_encode(["status" => "success", "data" => []]);
}

$conn->close();
?>
