<?php
include_once("dbconnect.php");
$user_email = $_POST['email'];
$prid = $_POST['prid'];

$sqldelete = "DELETE FROM tbl_products WHERE user_email = '$user_email' AND prid = '$prid'";
$stmt = $conn->prepare($sqldelete);
if ($stmt->execute()) {
    echo "success";
} else {
    echo "failed";
}
?>