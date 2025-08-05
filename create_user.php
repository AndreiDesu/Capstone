<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json");

include 'db.php';

// Get raw input and decode JSON if needed
$input = $_POST;
if (empty($input)) {
    $raw = file_get_contents("php://input");
    $input = json_decode($raw, true);
}

// Sanitize input
$firstname = $input['firstname'] ?? '';
$lastname = $input['lastname'] ?? '';
$mi = $input['mi'] ?? '';
$address = $input['address'] ?? '';
$email = $input['email'] ?? '';
$contact = $input['contact'] ?? '';
$password = $input['password'] ?? '';
$roleid = $input['roleid'] ?? 2; // Default to 2 if not provided

if (empty($firstname) || empty($lastname) || empty($email) || empty($password)) {
    echo json_encode(['status' => 'error', 'message' => 'Missing required fields']);
    exit;
}

// Hash the password before storing
$hashedPassword = password_hash($password, PASSWORD_DEFAULT);

$stmt = $conn->prepare("INSERT INTO users (firstname, lastname, mi, address, email, contact, password, roleid) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
$stmt->bind_param("sssssssi", $firstname, $lastname, $mi, $address, $email, $contact, $hashedPassword, $roleid);

if ($stmt->execute()) {
    echo json_encode(['status' => 'success', 'message' => 'User created successfully']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Failed to create user']);
}

$stmt->close();
$conn->close();
?>
