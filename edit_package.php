<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST");
header('Content-Type: application/json');

require_once 'db.php'; // include DB connection

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $required = ['package_type_id', 'package_name', 'day_type', 'week_schedule', 'hours', 'price', 'amenities_id'];
    $missing = array_filter($required, fn($key) => empty($_POST[$key]));

    if (!empty($missing)) {
        echo json_encode([
            "status" => "error",
            "message" => "Missing fields: " . implode(", ", $missing)
        ]);
        exit;
    }

    $id = $_POST['package_type_id'];
    $name = $_POST['package_name'];
    $dayType = $_POST['day_type'];
    $schedule = $_POST['week_schedule'];
    $hours = $_POST['hours'];
    $price = $_POST['price'];
    $amenitiesId = $_POST['amenities_id'];

    $query = "UPDATE packages SET 
                package_name = ?, 
                day_type = ?, 
                week_schedule = ?, 
                hours = ?, 
                price = ?, 
                amenities_id = ? 
              WHERE package_type_id = ?";

    $stmt = $conn->prepare($query);
    $stmt->bind_param("ssssisi", $name, $dayType, $schedule, $hours, $price, $amenitiesId, $id);

    if ($stmt->execute()) {
        echo json_encode([
            "status" => "success",
            "message" => "Package updated successfully"
        ]);
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Failed to update package"
        ]);
    }

    $stmt->close();
    $conn->close();
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Invalid request method"
    ]);
}
