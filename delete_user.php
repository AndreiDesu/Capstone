<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json");

include 'db.php';

$input = json_decode(file_get_contents("php://input"), true);
$id = $input['id'] ?? '';

if ($id) {
    $stmt = $conn->prepare("DELETE FROM users WHERE id=?");
    $stmt->bind_param("i", $id);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "User deleted"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Delete failed"]);
    }
    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "User ID is required"]);
}
$conn->close();
?>
