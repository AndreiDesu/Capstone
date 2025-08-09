<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

// Database connection
require_once 'db.php';

// Get the JSON input
$data = $_POST;

// Check if required fields are set
if (
    isset($data['package_name']) &&
    isset($data['day_type']) &&
    isset($data['week_schedule']) &&
    isset($data['hours']) &&
    isset($data['price']) &&
    isset($data['amenities_id'])
) {
    $package_name = $data['package_name'];
    $day_type = $data['day_type'];
    $week_schedule = $data['week_schedule'];
    $hours = $data['hours'];
    $price = $data['price'];
    $amenities_id = $data['amenities_id'];

    $sql = "INSERT INTO packages (package_name, day_type, week_schedule, hours, price, amenities_id)
            VALUES (?, ?, ?, ?, ?, ?)";
    
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sssssi", $package_name, $day_type, $week_schedule, $hours, $price, $amenities_id);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Package added successfully."]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to add package."]);
    }

    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Incomplete data."]);
}

$conn->close();
?>
