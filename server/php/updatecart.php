<?php
include_once("dbconnect.php");
$user_email = $_POST['email'];
$prid = $_POST['prid'];
$op = $_POST['op'];
$cartqty = $_POST['cartqty'];

if ($op == "addqty") {
    $sqlupdatecart = "UPDATE tbl_cart SET cartqty = cartqty+1 WHERE prid = '$prid' AND user_email = '$user_email'";
    if ($conn->query($sqlupdatecart) === TRUE) {
        echo "success";
    } else {
        echo "failed";
    }
}
if ($op == "removeqty") {
    if ($cartqty == 1) {
        $sqldelete = "DELETE FROM tbl_cart WHERE user_email = '$user_email' AND prid = '$prid'";
        $stmt = $conn->prepare($sqldelete);
        if ($stmt->execute()) {
            echo "success";
        } else {
        echo "failed";
        }
    } else {
        $sqlupdatecart = "UPDATE tbl_cart SET cartqty = cartqty-1 WHERE prid = '$prid' AND user_email = '$user_email'";
        if ($conn->query($sqlupdatecart) === TRUE) {
            echo "success";
        } else {
            echo "failed";
        }
    }
}
?>