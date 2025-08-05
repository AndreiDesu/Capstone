<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

require_once 'db.php'; // Include your central DB connection

$data = json_decode(file_get_contents("php://input"), true);
$email = $data['email'] ?? '';
$password = $data['password'] ?? '';

if (empty($email) || empty($password)) {
    echo json_encode(["status" => "error", "message" => "Email and password are required."]);
    exit();
}

$sql = "SELECT id, password, roleid FROM users WHERE email = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

$response = ["status" => "error", "message" => "Invalid credentials."];

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    
    // Use password_verify if you switch to hashed passwords
    if ($password === $user['password']) {
        $response = [
            "status" => "success",
            "message" => "Login successful.",
            "user_id" => $user['id'],
            "roleid" => $user['roleid']
        ];
    }
}

echo json_encode($response);
$stmt->close();
$conn->close();
?>
