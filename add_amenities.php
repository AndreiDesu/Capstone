<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json");

include 'db.php';

// Get POST data
$input = $_POST;
if (empty($input)) {
    $raw = file_get_contents("php://input");
    $input = json_decode($raw, true);
}

$name = $input['name'] ?? '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (empty($name)) {
        echo json_encode(['status' => 'error', 'message' => 'Amenity name is required']);
        exit;
    }

    $stmt = $conn->prepare("INSERT INTO amenities (name) VALUES (?)");
    $stmt->bind_param("s", $name);

    if ($stmt->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'Amenity added successfully']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Insert failed: ' . $stmt->error]);
    }

    $stmt->close();
    $conn->close();
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
}
