<?php
header('Content-Type: application/json');

// Include your existing database connection file
include 'db.php';

// Assume db.php sets up a `$conn` variable for the connection

// Check connection
if (!$conn) {
    http_response_code(500);
    echo json_encode([
        "status" => "error",
        "message" => "Database connection failed"
    ]);
    exit();
}

// Get POST data
$package_name = isset($_POST['package_name']) ? trim($_POST['package_name']) : '';
$day_type = isset($_POST['day_type']) ? trim($_POST['day_type']) : '';
$week_schedule = isset($_POST['week_schedule']) ? trim($_POST['week_schedule']) : '';
$hours = isset($_POST['hours']) ? trim($_POST['hours']) : '';
$price = isset($_POST['price']) ? trim($_POST['price']) : '';
$amenities_id = isset($_POST['amenities_id']) ? trim($_POST['amenities_id']) : '';

// Basic validation
if (empty($package_name) || empty($day_type) || empty($week_schedule) || empty($hours) || empty($price) || empty($amenities_id)) {
    http_response_code(400);
    echo json_encode([
        "status" => "error",
        "message" => "Please fill in all required fields."
    ]);
    exit();
}

// Prepare and bind
$stmt = $conn->prepare("INSERT INTO packages (package_name, day_type, week_schedule, hours, price, amenities_id) VALUES (?, ?, ?, ?, ?, ?)");
if (!$stmt) {
    http_response_code(500);
    echo json_encode([
        "status" => "error",
        "message" => "Prepare failed: " . $conn->error
    ]);
    exit();
}

$stmt->bind_param("sssidi", $package_name, $day_type, $week_schedule, $hours, $price, $amenities_id);

// Execute
if ($stmt->execute()) {
    echo json_encode([
        "status" => "success",
        "message" => "Package added successfully."
    ]);
} else {
    http_response_code(500);
    echo json_encode([
        "status" => "error",
        "message" => "Execute failed: " . $stmt->error
    ]);
}

$stmt->close();
$conn->close();
?>
