<?php
include_once("dbconnect.php");
$user_email = $_POST['email'];

$sqlloadcart = "SELECT * FROM tbl_cart INNER JOIN tbl_products ON tbl_cart.prid = tbl_products.prid WHERE tbl_cart.user_email = '$user_email'";
$result = $conn->query($sqlloadcart);

if ($result->num_rows > 0){
    $response["cart"] = array();
    while ($row = $result -> fetch_assoc()){
        $productlist = array();
        $productlist['prid'] = $row['prid'];
        $productlist['prname'] = $row['prname'];
        $productlist['prtype'] = $row['prtype'];
        $productlist['prprice'] = $row['prprice'];
        $productlist['cartqty'] = $row['cartqty'];
        $productlist['productqty'] = $row['prqty'];
        $productlist['datecreate'] = $row['datecreate'];
        array_push($response["cart"],$productlist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>