<?php
include_once("dbconnect.php");
$user_email = $_POST['email'];
$prid = $_POST['prid'];

$sqlcheckstock = "SELECT * FROM tbl_products WHERE prid = '$prid'";      //check product in stock
$resultstock = $conn->query($sqlcheckstock);
if ($resultstock->num_rows > 0) {
     while ($row = $resultstock->fetch_assoc()){
        $prqty = $row['prqty'];
        if ($prqty == 0) {      //product is out of stock
            echo "failed"; 
            return;
        } 
        else {
            echo $sqlcheckcart = "SELECT * FROM tbl_cart WHERE prid = '$prid' AND user_email = '$user_email'"; //check if the product is already in cart
            $resultcart = $conn->query($sqlcheckcart);
            if ($resultcart -> num_rows == 0) {        //product is not in the cart proceed with insert new
                echo $sqlinsertcart = "INSERT INTO tbl_cart (user_email, prid, cartqty) VALUES ('$user_email', '$prid', '1')";
                if ($conn->query($sqlinsertcart) === TRUE) {
                    echo "success";
                } else {
                    echo "failed";
                }
            } 
            else {       //if the product is in the cart, proceed with update
                echo $sqlupdatecart = "UPDATE tbl_cart SET cartqty = cartqty +1 WHERE prid = '$prid' AND user_email = '$user_email'";
                if ($conn->query($sqlupdatecart) === TRUE) {
                    echo "success";
                } 
                else {
                    echo "failed";
                }
            }
        }
    }
}
else {
    echo "failed";
}
?>