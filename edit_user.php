<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json");

include 'db.php';

$input = json_decode(file_get_contents("php://input"), true);

$id = $input['id'] ?? '';
$firstname = $input['firstname'] ?? '';
$lastname = $input['lastname'] ?? '';
$mi = $input['mi'] ?? '';
$address = $input['address'] ?? '';
$email = $input['email'] ?? '';
$contact = $input['contact'] ?? '';
$password = $input['password'] ?? '';
$roleid = $input['roleid'] ?? 2;

if ($id && $firstname && $lastname && $email && $password) {
    $stmt = $conn->prepare("UPDATE users SET firstname=?, lastname=?, mi=?, address=?, email=?, contact=?, password=?, roleid=? WHERE id=?");
    $stmt->bind_param("sssssssii", $firstname, $lastname, $mi, $address, $email, $contact, $password, $roleid, $id);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "User updated"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Update failed"]);
    }
    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Missing required fields"]);
}
$conn->close();
?>
