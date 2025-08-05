<?php
// ✅ Allow requests from Flutter Web (CORS fix)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Methods: POST");

// ✅ Include centralized DB connection
require_once 'db.php';

// ✅ Handle POST request from Flutter
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Read posted values
    $firstname = $_POST['firstname'];
    $lastname = $_POST['lastname'];
    $mi = $_POST['mi'];
    $address = $_POST['address'];
    $email = $_POST['email'];
    $contact = $_POST['contact'];
    $password = $_POST['password'];

    // Prepare SQL
    $stmt = $conn->prepare(
        "INSERT INTO users (firstname, lastname, mi, address, email, contact, password)
         VALUES (?, ?, ?, ?, ?, ?, ?)"
    );

    // Bind parameters
    $stmt->bind_param("sssssss", $firstname, $lastname, $mi, $address, $email, $contact, $password);

    // Execute and respond
    if ($stmt->execute()) {
        echo "Success";
    } else {
        echo "Error: " . $stmt->error;
    }

    // Close resources
    $stmt->close();
    $conn->close();
} else {
    echo "Only POST requests are allowed.";
}
?>
