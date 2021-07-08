<?php
$servername = "localhost";
$username   = "crimsonw_foodtrackadmin";
$password   = "M.E-VzA7gTBH";
$dbname     = "crimsonw_foodtrackdb";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>