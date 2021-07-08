<?php
include_once("dbconnect.php");
$prname = $_POST['prname'];

if ($prname == "all"){
    $sqlloadproducts = "SELECT * FROM tbl_products ORDER BY prid DESC";
}
else{
    $sqlloadproducts = "SELECT * FROM tbl_products WHERE prname LIKE '%$prname%'ORDER BY prid DESC";
}

$result = $conn->query($sqlloadproducts);

if ($result->num_rows > 0){
    $response["products"] = array();
    while ($row = $result -> fetch_assoc()){
        $productlist = array();
        $productlist['prid'] = $row['prid'];
        $productlist['prname'] = $row['prname'];
        $productlist['prtype'] = $row['prtype'];
        $productlist['prprice'] = $row['prprice'];
        $productlist['prqty'] = $row['prqty'];
        $productlist['datecreate'] = $row['datecreate'];
        array_push($response["products"],$productlist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>