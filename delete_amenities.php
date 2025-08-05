<?php
// Must be the FIRST output, even before whitespace
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Content-Type: application/json");

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

include 'db.php';

// Only allow POST after preflight
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
    exit;
}

// Process JSON or form input
$input = $_POST;
if (empty($input)) {
    $raw = file_get_contents("php://input");
    $input = json_decode($raw, true);
    if (!is_array($input)) {
        echo json_encode(['status' => 'error', 'message' => 'Invalid JSON input']);
        exit;
    }
}

$amenity_id = isset($input['amenity_id']) ? intval($input['amenity_id']) : null;

if (!$amenity_id) {
    echo json_encode(['status' => 'error', 'message' => 'Amenity ID is required']);
    exit;
}

$stmt = $conn->prepare(query: "DELETE FROM amenities WHERE amenity_id = ?");
if (!$stmt) {
    echo json_encode(['status' => 'error', 'message' => 'Prepare failed: ' . $conn->error]);
    exit;
}
$stmt->bind_param("i", $amenity_id);

if ($stmt->execute()) {
    echo json_encode(['status' => 'success', 'message' => 'Amenity deleted successfully']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Delete failed: ' . $stmt->error]);
}

$stmt->close();
$conn->close();
