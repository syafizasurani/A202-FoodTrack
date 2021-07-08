<?php
include_once("dbconnect.php");
$user_email = $_POST['email'];

$sqlloadpurchased = "SELECT * FROM tbl_purchased INNER JOIN tbl_products ON tbl_purchased.prid = tbl_products.prid";  //WHERE tbl_purchased.user_email = '$user_email'
$result = $conn->query($sqlloadpurchased);

if ($result->num_rows > 0){
    $response["purchased"] = array();
    while ($row = $result -> fetch_assoc()){
        $productlist = array();
        $productlist['prid'] = $row['prid'];
        $productlist['prname'] = $row['prname'];
        $productlist['prtype'] = $row['prtype'];
        $productlist['prprice'] = $row['prprice'];
        $productlist['purchased_qty'] = $row['purchased_qty'];
        $productlist['productqty'] = $row['prqty'];
        $productlist['datecreate'] = $row['datecreate'];
        array_push($response["purchased"],$productlist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>