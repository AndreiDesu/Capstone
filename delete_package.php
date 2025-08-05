<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST");

include 'db.php';
header('Content-Type: application/json');

// Use raw POST body if JSON
$input = $_POST;
if (empty($input)) {
    $raw = file_get_contents("php://input");
    $input = json_decode($raw, true);
}

$package_type_id = $input['package_type_id'] ?? '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (empty($package_type_id)) {
        echo json_encode(['status' => 'error', 'message' => 'Package ID required']);
        exit;
    }

    $stmt = $conn->prepare("DELETE FROM packages WHERE package_type_id = ?");
    $stmt->bind_param("i", $package_type_id);

    if ($stmt->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'Package deleted successfully']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Delete failed']);
    }

    $stmt->close();
    $conn->close();
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
}
