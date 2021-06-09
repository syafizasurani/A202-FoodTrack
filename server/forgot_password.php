<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '/home8/crimsonw/public_html/s271304/foodtrack/php/PHPMailer/src/Exception.php';
require '/home8/crimsonw/public_html/s271304/foodtrack/php/PHPMailer/src/PHPMailer.php';
require '/home8/crimsonw/public_html/s271304/foodtrack/php/PHPMailer/src/SMTP.php';

include_once("dbconnect.php");

$user_email = $_POST['email'];
$newotp = rand(1000,9999);
$newpass = random_password(10);
$passha = sha1($newpass);

$sql = "SELECT * FROM tbl_user WHERE user_email = '$user_email'";
    $result = $conn->query($sql);
    if ($result->num_rows > 0) {
        $sqlupdate = "UPDATE tbl_user SET otp = '$newotp', password = '$passha' WHERE user_email = '$user_email'";
        if ($conn->query($sqlupdate) === TRUE){
                sendEmail($newotp,$newpass,$user_email);
                echo 'success';
        }else{
                echo 'failed';
        }
    }else{
        echo "failed";
    }

function sendEmail($otp,$newpass,$user_email){
    $mail = new PHPMailer(true);
    $mail->SMTPDebug = 0;                                               //Disable verbose debug output
    $mail->isSMTP();                                                    //Send using SMTP
    $mail->Host       = 'mail.crimsonwebs.com';                         //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                                           //Enable SMTP authentication
    $mail->Username   = 'foodtrack@crimsonwebs.com';                    //SMTP username
    $mail->Password   = '}uyK8h9O%89I';                                 //SMTP password
    $mail->SMTPSecure = 'tls';         
    $mail->Port       = 587;
    
    $from = "foodtrack@crimsonwebs.com";
    $to = $user_email;
    $subject = "From FoodTrack. Reset your account";
    $message = "<p>Your account password has been reset. Please login again using the information below.</p><br><br><h3>Password:".$newpass."</h3><br><br>
    <a href='https://crimsonwebs.com/s271304/foodtrack/php/verify_account.php?email=".$user_email."&key=".$otp."'>Click Here to reactivate your account</a>";
    
    $mail->setFrom($from,"FoodTrack");
    $mail->addAddress($to);                                             //Add a recipient
    
    //Content
    $mail->isHTML(true);                                                //Set email format to HTML
    $mail->Subject = $subject;
    $mail->Body    = $message;
    $mail->send();
}

function random_password($length){
    //A list of characters that can be used in our random password
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    //Create blank string
    $password = '';
    //Get the index of the last character in our $characters string
    $characterListLength = mb_strlen($characters, '8bit') - 1;
    //Loop from 1 to the length that was specified
    foreach(range(1,$length) as $i){
        $password .=$characters[rand(0,$characterListLength)];
    }
    return $password;
}
?>